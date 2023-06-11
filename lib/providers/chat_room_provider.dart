// import 'package:dio/dio.dart';
import 'package:carpoolz_frontend/providers/ride_requests_provider.dart';
import 'package:carpoolz_frontend/widgets/ride_review.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/message.dart';
import '../providers/user_provider.dart';
import '../services/socket_services/socket_service.dart';
import '../services/api_services/trip_service.dart';
import '../screens/confirm_ride_screen.dart';
import '../screens/start_ride_screen.dart';

class ChatRoomProvider with ChangeNotifier {
  List<Message> _messages = [
    // Message('saaaadi16', 'Hello', Type.driver),
    // Message("laiba123", 'Hi', Type.passenger),
    // Message("laiba123", 'How are you?', Type.passenger),
    // Message("laiba123", 'I am fine, thank you.', Type.passenger),
    // Message("laiba123", 'How about you?', Type.driver),
    // Message("laiba123", 'I am fine too.', Type.driver),
    // Message("laiba123", 'Where are you from?', Type.passenger),
    // Message("laiba123", 'I am from India.', Type.passenger),
  ];
  String _receiverName = "";
  String senderName = "";
  Type senderType;

  ChatRoomProvider({required this.senderName, required this.senderType});

  List<Message> get messages => _messages;
  String get receiverName => _receiverName;
  bool _startRide = false;

  bool get startRide => _startRide;

  void addMessage(String userName, String text, Type userType) {
    _messages.insert(0, Message(userName, text, userType));
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  void setReceiverName(String name) {
    _receiverName = name;
    notifyListeners();
  }

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

  Future<void> sendMessage(
    String event,
    String userName,
    Type user,
    String text,
  ) async {
    Socket socketService = Socket();
    try {
      addMessage(userName, text, senderType);
      await socketService.emit(event, {
        'userName': userName,
        'text': text,
        'user': user == Type.passenger ? "passenger" : "driver",
      });
      // print("Response $response");
      // return response;
    } catch (e) {
      rethrow;
    }
  }

  void receiveMessage() {
    Socket socketService = Socket();
    socketService.on("$senderName/chat/message", (data) {
      print(data);
      addMessage(
        data['userName'],
        data['text'],
        data['user'] == "passenger" ? Type.passenger : Type.driver,
      );
    });
  }

  void startRideRequest() {
    Socket socketService = Socket();
    socketService.emit(
      "$_receiverName/start-ride",
      {
        'userName': senderName,
        'user': senderType == Type.passenger ? "passenger" : "driver",
      },
    );
    _startRide = true;
    notifyListeners();
  }

  void receiveStartRideRequest(BuildContext context) {
    Socket socketService = Socket();
    socketService.on("$senderName/start-ride", (data) async {
      print(data);

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Ride Request Confirmation"),
          content: Text("Do you want to confirm ride?"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () async {
                // print(rideRequests[0].toString());
                try {
                  Socket socketService = Socket();
                  socketService.emit(
                    "$_receiverName/confirm-ride",
                    {
                      'userName': senderName,
                      'user':
                          senderType == Type.passenger ? "passenger" : "driver",
                    },
                  );
                  _startRide = false;
                  final _currentType =
                      Provider.of<UserProvider>(context, listen: false)
                          .currentType;

                  if (_currentType == Type.passenger) {
                    try {
                      await TripService().startPassengerTrip(senderName);
                    } catch (e) {
                      print(e.toString());
                    }
                  }
                  Navigator.of(context)
                      .pushReplacementNamed(ConfirmRideScreen.routeName);
                  // notifyListeners();
                } catch (e) {
                  print(e.toString());
                } finally {
                  // Navigator.of(context).pop();
                }
              },
              child: Text("Yes"),
            ),
          ],
        ),
      );

      // _startRide = false;
      // notifyListeners();
    });
  }

  void receiveConfirmRide(BuildContext context) {
    Socket socketService = Socket();
    socketService.on("$senderName/confirm-ride", (data) async {
      print(data);
      _startRide = false;
      final _currentType =
          Provider.of<UserProvider>(context, listen: false).currentType;

      if (_currentType == Type.passenger) {
        try {
          await TripService().startPassengerTrip(senderName);
        } catch (e) {
          print(e.toString());
        }
      }

      notifyListeners();
    });
  }

  void receiveStartRide(BuildContext context) {
    Socket socketService = Socket();
    socketService.on("start-ride", (data) async {
      print(data);
      Navigator.of(context).pushReplacementNamed(StartRideScreen.routeName);

      notifyListeners();
    });
  }

  void sendStartRide() {
    Socket socketService = Socket();
    socketService.emit(
      "start-ride",
      {
        'userName': senderName,
        'user': senderType == Type.passenger ? "passenger" : "driver",
      },
    );
  }

  void receiveEndRide(BuildContext context) {
    Socket socketService = Socket();
    socketService.on("end-ride", (data) async {
      print(data);
      // Navigator.of(context).pushReplacementNamed(StartRideScreen.routeName);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return RideReview();
        },
      );

      notifyListeners();
    });
  }

  void sendEndRide() {
    Socket socketService = Socket();
    socketService.emit(
      "end-ride",
      {
        'userName': senderName,
        'user': senderType == Type.passenger ? "passenger" : "driver",
      },
    );
  }
}
