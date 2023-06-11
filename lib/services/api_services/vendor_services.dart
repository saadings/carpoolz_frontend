import 'package:dio/dio.dart';

import './base_service.dart';

class VendorService extends BaseService {
  Future<void> registerVendor(
    String userName,
    String cnic,
  ) async {
    try {
      await dio.post('/vendors/register', data: {
        "userName": userName,
        "cnic": cnic,
      });
    } on DioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
