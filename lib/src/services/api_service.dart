import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:iconify_design_flutter/src/utils/constants.dart';

class APIService {
  static Dio _dio = Dio(
    BaseOptions(
      baseUrl: PackageConstants.iconifyURL,
      receiveTimeout: Duration(seconds: 30),
      responseType: ResponseType.plain,
    ),
  );

  static void setDioForTesting(Dio dio) {
    _dio = dio;
  }

  static Future<Either<DioException, Response>> getRequest(
    String endpoint,
  ) async {
    try {
      final response = await _dio.get(endpoint);
      return Right(response);
    } on DioException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
        DioException(
          message: "Unexpected error: $e",
          requestOptions: RequestOptions(path: endpoint),
        ),
      );
    }
  }
}
