
import 'package:carpoolz_frontend/services/api_services/store_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/api_services/socket_service.dart';


class Stores {
  final storeID;
  final storeName;
  final address;
  final latitude;
  final longitude;
  final contactNumber;
  final timing;

  Stores({required this.storeID,
          required this.storeName,
          required this.address,
          required this.latitude, 
          required this.longitude,
          required this.contactNumber,
          required this.timing});
}

class StoreListProvider with ChangeNotifier {
  
  List<Stores> storeList = [];
  final userName;

  StoreListProvider({
    this.userName
  });

Future<void> getStoreDetails() async {
  try {
    final response = await StoreService().getStoreDetails(userName.toLowerCase());
        storeList = response.data.map((storeData) {
      return Stores(
        storeID: storeData['storeID'],
        storeName: storeData['storeName'],
        address: storeData['address'],
        latitude: storeData['latitude'],
        longitude: storeData['longitude'],
        contactNumber: storeData['contactNumber'],
        timing: storeData['timing'],
      );
    }).toList();
    notifyListeners(); // Notify listeners that the storeList has been updated
  } catch (e) {
    rethrow;
  }
}

}
