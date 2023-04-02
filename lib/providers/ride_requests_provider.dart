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

  void connectSocket() {
    SocketService socketService = SocketService();
    socketService.connect();

    socketService.on('connect', (_) {
      print('connected: ${socketService.socket!.id}');
    });

    socketService.on('disconnect', (_) {
      print('disconnected: ${socketService.socket!.id}');
    });
  }

  void disconnectSocket() {
    SocketService socketService = SocketService();
    socketService.disconnect();
  }

  void addRideRequest(var rideRequest) {
    print("ride req data: ${rideRequest}");
    _rideRequests.add(rideRequest);
    // print(_rideRequests[0]);
    notifyListeners();
  }

  void getRideRequests(String event) {
    SocketService socketService = SocketService();
    socketService.on(event, (data) {
      print("This is the data! $data");
      addRideRequest(data);
    });
  }

  // void removeRideRequest(String rideRequestId) {
  //   _rideRequests.removeWhere((rideRequest) => rideRequest['id'] == rideRequestId);
  //   notifyListeners();
  // }
}
