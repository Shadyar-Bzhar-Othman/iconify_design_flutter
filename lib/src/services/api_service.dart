import 'package:dio/dio.dart';
import 'package:iconify_design_flutter/src/utils/constants.dart';

class APIService {
  static Dio _dio = Dio(
    BaseOptions(
      baseUrl: PackageConstants.iconifyURL,
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.plain,
    ),
  );

  /// Override Dio for tests.
  static void setDioForTesting(Dio dio) {
    _dio = dio;
  }

  /// Fetches SVG text from Iconify. Returns null on failure.
  static Future<String?> getSvg(String endpoint) async {
    try {
      final response = await _dio.get<String>(endpoint);
      final data = response.data;
      if (data == null || data.isEmpty) return null;
      return data;
    } on DioException {
      return null;
    } catch (_) {
      return null;
    }
  }
}
