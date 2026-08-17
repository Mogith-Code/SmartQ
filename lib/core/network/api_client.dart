import 'package:dio/dio.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient({String baseUrl = 'https://api.smartq.app/v1'}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  Dio get client => _dio;
}
