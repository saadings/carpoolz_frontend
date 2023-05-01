// import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/message.dart';
import '../providers/user_provider.dart';
import '../services/socket_services/socket_service.dart';

class ChatRoomProvider with ChangeNotifier {
  List<Message> _messages = [
    Message('saaaadi16', 'Hello', Type.driver),
    Message("laiba123", 'Hi', Type.passenger),
    Message("laiba123", 'How are you?', Type.passenger),
    Message("laiba123", 'I am fine, thank you.', Type.passenger),
    Message("laiba123", 'How about you?', Type.driver),
    Message("laiba123", 'I am fine too.', Type.driver),
    Message("laiba123", 'Where are you from?', Type.passenger),
    Message("laiba123", 'I am from India.', Type.passenger),
  ];
  String _receiverName = "";
  String senderName = "";
  Type senderType;

  ChatRoomProvider({required this.senderName, required this.senderType});

  List<Message> get messages => _messages;
  String get receiverName => _receiverName;

  void addMessage(String userName, String text, Type userType) {
    _messages.insert(0, Message(userName, text, userType));
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
}
