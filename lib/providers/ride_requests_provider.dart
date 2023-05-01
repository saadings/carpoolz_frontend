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
  bool _requestingRide = false;
  RideRequestProvider({required this.userName});

  List<Map<String, dynamic>> get rideRequests {
    return [..._rideRequests];
  }

  bool get requestingRide {
    return _requestingRide;
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

    int index = _rideRequests.indexWhere(
        (element) => element['userName'] == rideRequest['userName']);
    if (index == -1) {
      _rideRequests.add(rideRequest);
      notifyListeners();
    }

    // _rideRequests.insert(index, rideRequest);
    // print(_rideRequests[0]);
    // notifyListeners();
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
    try {
      final response = await socketService.emit(event, data);
      print("Response: $response");
    } catch (e) {
      rethrow;
    }
  }

  void startChatRequest() {
    _requestingRide = true;
    notifyListeners();
  }

  void receiveChatRequest() {
    Socket socketService = Socket();
    socketService.on(
      '$userName/chat',
      (data) {
        print("This is the data! $data");
        _requestingRide = false;
        notifyListeners();
        // Navigator.of(context).pushNamed(ChatRoomScreen.routeName);
      },
    );
  }

  // void removeRideRequest(String rideRequestId) {
  //   _rideRequests.removeWhere((rideRequest) => rideRequest['id'] == rideRequestId);
  //   notifyListeners();
  // }
}
