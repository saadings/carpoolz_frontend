import 'package:carpoolz_frontend/services/api_services/deal_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/api_services/socket_service.dart';

class DealProvider with ChangeNotifier {
  var storeID;
  String title = "";
  String description = "";
  String price = "";

  // DealProvider({
  //   // required this.storeID,
  //   //  this.storeName,
  //   //   this.address,
  //   //   this.latLang,
  //   //  this.contactNumber,
  //   //  this.timing,
  // });

  void setStoreID(var storeID) {
    this.storeID = storeID;
  }

  Future<void> addDeal(String title, String description, String price) async {
    try {
      await DealService().addStoreDeals(storeID, title, description, price);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
