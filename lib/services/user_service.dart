import 'package:dio/dio.dart';
import './base_service.dart';

class UserService extends BaseService {
  Future<Response> login(String userName, String password) async {
    try {
      final response = await dio.post('/users/login', data: {
        'userName': userName,
        'password': password,
      });
      // print(response.data);

      return response;
    } on DioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
