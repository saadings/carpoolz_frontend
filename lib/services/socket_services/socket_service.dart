import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  static final String _serverUrl =
      'https://carpoolz.herokuapp.com/'; // Replace with your server URL

  static Socket? _socket;

  static void init() {
    if (_socket == null) {
      _socket = io(
        _serverUrl,
        <String, dynamic>{
          'transports': ['websocket'],
          'reconnectionAttempts': -1,
        },
      );
    }
  }

  static void connect() {
    if (_socket != null) {
      _socket?.connect();
    }
  }

  static void disconnect() {
    if (_socket != null) {
      _socket?.disconnect();
    }
  }

  static void emit(String event, dynamic data) {
    if (_socket != null) {
      _socket?.emit(event, data);
    }
  }

  static void on(String event, Function(dynamic) callback) {
    if (_socket != null) {
      _socket?.on(event, callback);
    }
  }
}
