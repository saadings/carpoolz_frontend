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
      return await dio.post(
        '/activate/driver',
        data: {
          'userName': userName,
          'origin': {
            'latitude': origin.latitude,
            'longitude': origin.longitude,
          },
          'destination': {
            'latitude': destination.latitude,
            'longitude': destination.longitude,
          },
          'route': route,
        },
      );
    } on DioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getRidesPassenger() async {
    try {
      return await dio.get('/activate/passenger');
    } on DioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
