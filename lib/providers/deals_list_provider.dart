import 'package:carpoolz_frontend/services/api_services/deal_service.dart';
import 'package:carpoolz_frontend/services/api_services/store_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/api_services/socket_service.dart';

class Deals {
  final String storeID;
  final String title;
  final String description;
  final String price;

  Deals({
    required this.storeID,
    required this.title,
    required this. description,
    required this.price,
  });
}

class DealListProvider with ChangeNotifier {
  List<Deals> DealList = [];


  Future<void> getDeals(var storeID) async {
    try {
      final response =
          await DealService().getStoreDetails(storeID);
      // print(response.data);

      DealList = (response.data['data'] as List<dynamic>).map((dealData) {
        return Deals(
          storeID: dealData['_id'],
          title: dealData['title'],
          description: dealData['description'],
          price: dealData['price'],

        );
      }).toList();

      notifyListeners(); // Notify listeners that the storeList has been updated
    } catch (e) {
      rethrow;
    }
  }

}
