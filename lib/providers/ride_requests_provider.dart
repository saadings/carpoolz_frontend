import 'package:flutter/material.dart';

import '../services/socket_services/socket_service.dart';

class RideRequestProvider with ChangeNotifier {
  String userName = "";
  var _rideRequests = [];

  RideRequestProvider({required this.userName});

  get rideRequests {
    return [..._rideRequests];
  }

  // String get userName {
  //   return userName;
  // }

  void addRideRequest(var rideRequest) {
    // print("ride req data: ${rideRequest}");
    _rideRequests.add(rideRequest);
    print(_rideRequests[0]);
    notifyListeners();
  }

  void getRideRequests(String event) {
    print(event);
    try {
      SocketService().on(
        event,
        (data) {
          // Listen for 'message' event
          print("event $event");
          print("data $data");
          addRideRequest(data); // Update UI with received data
          // notifyListeners();
        },
      );
    } catch (e) {
      print(e);
    }
    // SocketService().connect();
  }

  // void removeRideRequest(String rideRequestId) {
  //   _rideRequests.removeWhere((rideRequest) => rideRequest['id'] == rideRequestId);
  //   notifyListeners();
  // }
}
