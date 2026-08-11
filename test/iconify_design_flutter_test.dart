import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:iconify_design_flutter/iconify_design_flutter.dart';
import 'package:iconify_design_flutter/src/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _homeSvg =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"><path fill="currentColor" d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg>';
const _heartSvg =
    '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"><path fill="currentColor" d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/></svg>';

class _FakeIconifyInterceptor extends Interceptor {
  _FakeIconifyInterceptor(this.responses);

  final Map<String, String> responses;
  final Map<String, int> callCounts = <String, int>{};

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final path = options.path.replaceFirst(RegExp(r'^/'), '');
    callCounts[path] = (callCounts[path] ?? 0) + 1;

    final body = responses[path];
    if (body == null) {
      handler.reject(
        DioException(
          requestOptions: options,
          response: Response(requestOptions: options, statusCode: 404),
          type: DioExceptionType.badResponse,
        ),
      );
      return;
    }

    handler.resolve(
      Response<String>(
        requestOptions: options,
        data: body,
        statusCode: 200,
      ),
    );
  }
}

void main() {
  late Dio dio;
  late _FakeIconifyInterceptor interceptor;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    IconService.clearMemoryCache();

    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.iconify.design/',
        responseType: ResponseType.plain,
      ),
    );
    interceptor = _FakeIconifyInterceptor({
      'mdi/home.svg': _homeSvg,
      'mdi/heart.svg': _heartSvg,
    });
    dio.interceptors.add(interceptor);
    APIService.setDioForTesting(dio);
  });

  group('IconService', () {
    test('returns null for invalid icon format', () async {
      final result = await IconService.getIcon('not-a-valid-icon');
      expect(result, isNull);
    });

    test('fetches and caches icon in memory and prefs', () async {
      final first = await IconService.getIcon('mdi:home');
      expect(first, _homeSvg);
      expect(interceptor.callCounts['mdi/home.svg'], 1);

      final second = await IconService.getIcon('mdi:home');
      expect(second, _homeSvg);
      expect(interceptor.callCounts['mdi/home.svg'], 1);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('icon:mdi:home'), _homeSvg);
    });

    test('dedupes in-flight requests for the same icon', () async {
      final delayedDio = Dio(
        BaseOptions(
          baseUrl: 'https://api.iconify.design/',
          responseType: ResponseType.plain,
        ),
      );
      var calls = 0;
      delayedDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            calls++;
            await Future<void>.delayed(const Duration(milliseconds: 40));
            handler.resolve(
              Response<String>(
                requestOptions: options,
                data: _homeSvg,
                statusCode: 200,
              ),
            );
          },
        ),
      );
      APIService.setDioForTesting(delayedDio);
      IconService.clearMemoryCache();

      final results = await Future.wait([
        IconService.getIcon('mdi:home'),
        IconService.getIcon('mdi:home'),
        IconService.getIcon('mdi:home'),
      ]);

      expect(results, everyElement(_homeSvg));
      expect(calls, 1);
    });

    test('loads from disk when memory is cleared', () async {
      await IconService.getIcon('mdi:home');
      expect(interceptor.callCounts['mdi/home.svg'], 1);

      IconService.clearMemoryCache();

      final fromDisk = await IconService.getIcon('mdi:home');
      expect(fromDisk, _homeSvg);
      expect(interceptor.callCounts['mdi/home.svg'], 1);
    });

    test('clearAllCaches removes disk entries', () async {
      await IconService.getIcon('mdi:home');
      await IconService.clearAllCaches();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('icon:mdi:home'), isFalse);

      final again = await IconService.getIcon('mdi:home');
      expect(again, _homeSvg);
      expect(interceptor.callCounts['mdi/home.svg'], 2);
    });
  });

  group('IconifyIcon', () {
    testWidgets('renders fetched svg', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IconifyIcon(icon: 'mdi:home', size: 32),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(IconifyIcon), findsOneWidget);
    });

    testWidgets('updates when icon prop changes', (tester) async {
      var icon = 'mdi:home';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    IconifyIcon(icon: icon, size: 24),
                    TextButton(
                      onPressed: () => setState(() => icon = 'mdi:heart'),
                      child: const Text('swap'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('swap'));
      await tester.pumpAndSettle();

      expect(find.byType(IconifyIcon), findsOneWidget);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('icon:mdi:heart'), _heartSvg);
      expect(interceptor.callCounts['mdi/home.svg'], 1);
      expect(interceptor.callCounts['mdi/heart.svg'], 1);
    });

    testWidgets('invalid icon does not throw', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IconifyIcon(icon: 'bad-icon'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('uses IconTheme color and size by default', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: IconTheme(
              data: IconThemeData(color: Colors.red, size: 40),
              child: IconifyIcon(icon: 'mdi:home'),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(IconifyIcon), findsOneWidget);
    });
  });
}
