import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './base_service.dart';

class RideService extends BaseService {
  Future<Response> getRidesDriver(
    String userName,
    LatLng origin,
    LatLng destination,
    var route,
  ) async {
    try {
      return await dio.post('/active/driver');
    } on DioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getRidesPassenger() async {
    try {
      return await dio.get('/active/passenger');
    } on DioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
