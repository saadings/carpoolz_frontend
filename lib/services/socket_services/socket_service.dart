import 'package:dio/dio.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../api_services/socket_service.dart';

class Socket {
  static final Socket _instance = Socket._internal();

  factory Socket() {
    return _instance;
  }

  IO.Socket? _socket;

  Socket._internal();

  void connect() {
    if (_socket == null) {
      _socket = IO.io('https://carpoolz.herokuapp.com/', <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });
    }
    _socket!.connect();
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
    }
  }

  IO.Socket? get socket => _socket;

  void on(String event, Function(dynamic data) callback) {
    if (_socket != null) {
      _socket!.on(event, callback);
    }
  }

  Future<Response> emit(String event, dynamic data) async {
    // if (_socket != null) {
    // _socket!.emit(event, data);
    // }
    try {
      final response = await SocketService().emit(event, data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
