import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import './base_service.dart';

class DealService extends BaseService {
  Future<Response> addStoreDeals(
      String storeID, String title, String description, String price) async {
    try {
      return await dio.post('/stores/deals/add', data: {
        "storeID": storeID,
        "title": title,
        "description": description,
        "price": price,
      });
    } on DioError catch (_) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
