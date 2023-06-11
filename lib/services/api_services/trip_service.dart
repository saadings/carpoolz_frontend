import 'package:dio/dio.dart';

import './base_service.dart';

class TripService extends BaseService {
  Future<void> startPassengerTrip(
    String userName,
  ) async {
    try {
      await dio.post('/trip/passenger', data: {
        "userName": userName,
      });
    } on DioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
