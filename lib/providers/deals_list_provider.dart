
import 'package:carpoolz_frontend/services/api_services/store_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../services/api_services/socket_service.dart';


class DealsListProvider with ChangeNotifier {
 
  final storeID;

  DealsListProvider({
    this.storeID
  });

Future<void> getDealsList() async {
  try {
   
  } catch (e) {
    rethrow;
  }
}

}
