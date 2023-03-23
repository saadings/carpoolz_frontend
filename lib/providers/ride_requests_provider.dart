import 'package:flutter/material.dart';

import '../services/socket_services/socket_service.dart';

class RideRequestProvider with ChangeNotifier {
  String userName = "";
  List<Map<String, dynamic>> _rideRequests = [];

  RideRequestProvider({required this.userName});

  List<Map<String, dynamic>> get rideRequests {
    return [..._rideRequests];
  }

  // String get userName {
  //   return userName;
  // }

  void _addRideRequest(Map<String, dynamic> rideRequest) {
    _rideRequests.add(rideRequest);
    notifyListeners();
  }

  void getRideRequests(String event) {
    SocketService.on(event, (data) {
      // Listen for 'message' event
      print("event $event");
      print("data $data");
      _addRideRequest(data); // Update UI with received data
      // notifyListeners();
    });
    SocketService.connect();
  }

  // void removeRideRequest(String rideRequestId) {
  //   _rideRequests.removeWhere((rideRequest) => rideRequest['id'] == rideRequestId);
  //   notifyListeners();
  // }
}
