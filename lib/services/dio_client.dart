import 'package:dio/dio.dart';

class DioClient {
  static Dio _dio;

  static Dio get dio {
    if (_dio == null) {
      _dio = Dio(BaseOptions(
        baseUrl: 'http://192.168.100.190:8000',
        // connectTimeout: 5000, // 5 seconds
        // receiveTimeout: 5000, // 5 seconds
      ));

      // Request interceptor
      _dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            // Do something before the request is sent
            print('Sending request to ${options.uri}');
            handler.next(options);
          },
        ),
      );

      // Response interceptor
      _dio.interceptors.add(
        InterceptorsWrapper(
          onResponse: (response, handler) {
            // Do something with the response data
            print('Received response from ${response.requestOptions.uri}');
            handler.next(response);
          },
          onError: (DioError e, handler) {
            // Do something with the error
            print('Error ${e.response?.statusCode}: ${e.message}');
            handler.next(e);
          },
        ),
      );
    }
    return _dio;
  }
}
