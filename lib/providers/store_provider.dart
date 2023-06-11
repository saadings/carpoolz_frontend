import 'package:carpoolz_frontend/services/api_services/store_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/api_services/socket_service.dart';

class StoreProvider with ChangeNotifier {
  final userName;
  String storeName = "";
  String address = "";
  LatLng? latLang;
  String contactNumber = "";
  String timing = "";

  StoreProvider({
    required this.userName,
    //  this.storeName,
    //   this.address,
    //   this.latLang,
    //  this.contactNumber,
    //  this.timing,
  });

  void setLatLang(LatLng latlang, String address) {
    this.latLang = latlang;
    this.address = address;
  }

  Future<void> registerStore(
      String storeName, String contactNumber, String timing) async {
    try {
      await StoreService().registerStore(userName.toLowerCase(), storeName,
          address, latLang!, contactNumber, timing);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getStoreDetails() async {
    try {
      return await StoreService().getStoreDetails(userName.toLowerCase());
    } catch (e) {
      rethrow;
    }
  }
}
