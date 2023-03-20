import 'package:dio/dio.dart';
import '../local_storage_services/access_token_service.dart';

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
          onRequest: (options, handler) async {
            // Do something before the request is sent
            print('Sending request to ${options.uri}');

            if (!options.uri.toString().contains("/users/") ||
                options.uri.toString().contains("/users/refresh/token")) {
              final accessToken = await AccessTokenService()
                  .getToken(AccessTokenService.accessTokenKey);
              options.headers['Authorization'] = 'Bearer $accessToken';
              print(
                  "Token added + ${options.headers['Authorization'].toString()}");
            }

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
          onError: (DioError e, handler) async {
            // Do something with the error
            print(
                'Error ${e.response?.statusCode}: ${e.message} & data: ${e.response?.data}');
            // final prevReq = e;

            if (e.response!.data['message']
                .toString()
                .contains("JWT expired.")) {
              print("Token expired");

              try {
                final refreshToken = await AccessTokenService()
                    .getToken(AccessTokenService.refreshTokenKey);

                final Response response = await _dio.post(
                  '/users/refresh/token',
                  data: {
                    "refreshToken": refreshToken,
                  },
                );

                await AccessTokenService().storeToken(
                  AccessTokenService.accessTokenKey,
                  response.data['accessToken'],
                );

                _dio
                    .request(
                      e.requestOptions.path,
                      data: e.requestOptions.data,
                      options: Options(method: e.requestOptions.method),
                    )
                    .then((value) => handler.resolve(value))
                    .catchError((e) {
                  handler.reject(e);
                });
              } catch (e) {
                throw e;
              }
            } else {
              handler.next(e);
            }

            // handler.next(e);
          },
        ),
      );
    }
    return _dio;
  }
}
