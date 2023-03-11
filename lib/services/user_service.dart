import 'package:dio/dio.dart';
import './base_service.dart';

class UserService extends BaseService {
  Future<void> getUser(int id) async {
    try {
      final response = await dio.post('/', data: {});
      print(response.data['title']);

      // return response.data;
      // return User.fromJson(response.data);
    } on DioError catch (e) {
      throw e.message;
    } catch (e) {
      throw e;
    }
  }
}
