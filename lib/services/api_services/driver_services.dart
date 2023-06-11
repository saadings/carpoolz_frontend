import 'package:dio/dio.dart';

import './base_service.dart';

class DriverService extends BaseService {
  Future<void> registerDriver(
    String userName,
    String cnic,
    String licenseNo,
  ) async {
    try {
      await dio.post('/drivers/register', data: {
        "userName": userName,
        "cnic": cnic,
        "licenseNo": licenseNo,
      });
    } on DioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
