import 'package:carpoolz_frontend/services/api_services/store_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/api_services/socket_service.dart';

class Stores {
  final String storeID;
  final String storeName;
  final String address;
  final String latitude;
  final String longitude;
  final String contactNumber;
  final String timing;

  Stores({
    required this.storeID,
    required this.storeName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.contactNumber,
    required this.timing,
  });
}

class StoreListProvider with ChangeNotifier {
  List<Stores> storeList = [];
  final userName;

  StoreListProvider({this.userName});

  Future<void> getStoreDetails() async {
    try {
      final response =
          await StoreService().getStoreDetails(userName.toLowerCase());
      print(response.data);

      storeList = (response.data['data'] as List<dynamic>).map((storeData) {
        return Stores(
          storeID: storeData['_id'],
          storeName: storeData['name'],
          address: storeData['address'],
          latitude: storeData['latitude']['\$numberDecimal'],
          longitude: storeData['longitude']['\$numberDecimal'],
          contactNumber: storeData['contactNumber'],
          timing: storeData['timing'],
        );
      }).toList();

      notifyListeners(); // Notify listeners that the storeList has been updated
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getPassengerStores() async {
    try {
      final response = await StoreService().getPassengerStores(userName);
      // print(response.data['data']);
      storeList = (response.data['data'] as List<dynamic>).map((storeData) {
        return Stores(
          storeID: storeData['_id'],
          storeName: storeData['name'],
          address: storeData['address'],
          latitude: storeData['latitude']['\$numberDecimal'],
          longitude: storeData['longitude']['\$numberDecimal'],
          contactNumber: storeData['contactNumber'],
          timing: storeData['timing'],
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
