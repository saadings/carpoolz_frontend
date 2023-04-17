import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  IO.Socket? _socket;

  SocketService._internal();

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

  void emit(String event, dynamic data) {
    if (_socket != null) {
      _socket!.emit(event, data);
    }
  }
}
