import 'package:flutter/material.dart';

import '../services/socket_services/socket_service.dart';

class RideRequestProvider with ChangeNotifier {
  String userName = "";
  List<Map<String, dynamic>> _rideRequests = [
    {
      "userName": "Saad",
      "origin": {
        "longitude": {"\$numberDecimal": "74.4034771"},
        "latitude": {"\$numberDecimal": "31.4859315"},
        "_id": {"\$oid": "643a76fc4d00792c6b1db867"}
      },
    },
    {
      "userName": "Addullah",
      "origin": {
        "longitude": {"\$numberDecimal": "74.4034771"},
        "latitude": {"\$numberDecimal": "31.4859315"},
        "_id": {"\$oid": "643a76fc4d00792c6b1db867"}
      },
    },
    {
      "userName": "Laiba",
      "origin": {
        "longitude": {"\$numberDecimal": "74.4034771"},
        "latitude": {"\$numberDecimal": "31.4859315"},
        "_id": {"\$oid": "643a76fc4d00792c6b1db867"}
      },
    },
  ];

  RideRequestProvider({required this.userName});

  List<Map<String, dynamic>> get rideRequests {
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

  void addRideRequest(Map<String, dynamic> rideRequest) {
    // print("ride req data: ${rideRequest}");
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

  void emitRideRequest(String event, Map<String, dynamic> data) {
    SocketService socketService = SocketService();
    socketService.emit(event, data);
  }

  // void removeRideRequest(String rideRequestId) {
  //   _rideRequests.removeWhere((rideRequest) => rideRequest['id'] == rideRequestId);
  //   notifyListeners();
  // }
}
