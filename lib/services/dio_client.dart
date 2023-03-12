import 'package:dio/dio.dart';

class DioClient {
  static var _dio;

  static Dio get dio {
    if (_dio == null) {
      _dio = Dio(BaseOptions(
        baseUrl: 'https://carpoolz.herokuapp.com',
        connectTimeout: const Duration(seconds: 10), // 5 seconds
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
      // _dio.interceptors.add(
      //   InterceptorsWrapper(
      //     onResponse: (response, handler) {
      //       // Do something with the response data
      //       print('Received response from ${response.requestOptions.uri}');
      //       handler.next(response);
      //     },
      //     // onError: (DioError e, handler) {
      //     //   // Do something with the error
      //     //   print('Error ${e.response?.statusCode}: ${e.message}');
      //     //   handler.next(e);
      //     // },
      //   ),
      // );
    }
    return _dio;
  }
}
