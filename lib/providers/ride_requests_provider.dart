import 'package:flutter/material.dart';

import '../services/socket_services/socket_service.dart';

class RideRequestProvider with ChangeNotifier {
  String userName = "";
  List<Map<String, dynamic>> _rideRequests = [
    // {
    //   "userName": "saaaadi16",
    //   "origin": {
    //     "longitude": {"\$numberDecimal": "74.4034771"},
    //     "latitude": {"\$numberDecimal": "31.4859315"},
    //     "_id": {"\$oid": "643a76fc4d00792c6b1db867"}
    //   },
    // },
    // {
    //   "userName": "Addullah",
    //   "origin": {
    //     "longitude": {"\$numberDecimal": "74.4034771"},
    //     "latitude": {"\$numberDecimal": "31.4859315"},
    //     "_id": {"\$oid": "643a76fc4d00792c6b1db867"}
    //   },
    // },
    // {
    //   "userName": "Laiba",
    //   "origin": {
    //     "longitude": {"\$numberDecimal": "74.4034771"},
    //     "latitude": {"\$numberDecimal": "31.4859315"},
    //     "_id": {"\$oid": "643a76fc4d00792c6b1db867"}
    //   },
    // },
  ];

  RideRequestProvider({required this.userName});

  List<Map<String, dynamic>> get rideRequests {
    return [..._rideRequests];
  }

  // String get userName {
  //   return userName;
  // }

  void connectSocket() {
    Socket socketService = Socket();
    socketService.connect();

    socketService.on('connect', (_) {
      print('connected: ${socketService.socket!.id}');
    });

    socketService.on('disconnect', (_) {
      print('disconnected: ${socketService.socket!.id}');
    });
  }

  void disconnectSocket() {
    Socket socketService = Socket();
    socketService.disconnect();
  }

  void addRideRequest(Map<String, dynamic> rideRequest) {
    // print("ride req data: ${rideRequest}");
    _rideRequests.add(rideRequest);
    // print(_rideRequests[0]);
    notifyListeners();
  }

  void getRideRequests(String event) {
    Socket socketService = Socket();
    socketService.on(event, (data) {
      print("This is the data! $data");
      addRideRequest(data);
    });
  }

  Future<void> emitRideRequest(String event, Map<String, dynamic> data) async {
    Socket socketService = Socket();
    // print("Emitting data: $data");
    // print("Emitting event: $event");
    final response = await socketService.emit(event, data);
    print("Response: $response");
  }

  // void removeRideRequest(String rideRequestId) {
  //   _rideRequests.removeWhere((rideRequest) => rideRequest['id'] == rideRequestId);
  //   notifyListeners();
  // }
}
