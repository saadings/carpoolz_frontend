import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import './base_service.dart';

class StoreService extends BaseService {
  Future<void> registerStore(
    String userName,
    String storeName,
    String address,
    LatLng latLng,
    String contactNumber,
    String timing,
  ) async {
    try {
      await dio.post('/vendors/register/store', data: {
        "userName": userName,
        "storeName": storeName,
        "address": address,
        "longitude": latLng.longitude,
        "latitude": latLng.latitude,
        "contactNumber": contactNumber,
        "timing": timing,

      });
    } on DioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
