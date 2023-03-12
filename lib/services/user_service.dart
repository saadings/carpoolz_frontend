import 'package:dio/dio.dart';
import './base_service.dart';

class UserService extends BaseService {
  Future<void> register(
    String userName,
    String email,
    String firstName,
    String lastName,
    String contactNumber,
    String gender,
    String password,
  ) async {
    try {
      await dio.post('/users/register', data: {
        "userName": userName,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "contactNumber": contactNumber,
        "gender": gender,
        'password': password,
      });
    } on DioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

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

  Future<void> verify(String userName, String otp) async {
    try {
      await dio.post('/users/verify/otp', data: {
        'userName': userName,
        'otp': otp,
      });
    } on DioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resendOtp(String userName) async {
    try {
      await dio.post('/users/resend/otp', data: {
        'userName': userName,
      });
    } on DioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
