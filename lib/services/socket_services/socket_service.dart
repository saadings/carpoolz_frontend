import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  final String _serverUrl = 'https://carpoolz.herokuapp.com/';

  IO.Socket? _socket;

  IO.Socket? get socket => _socket;

  void init() {
    if (_socket == null) {
      _socket = IO.io(
        'https://carpoolz.herokuapp.com/',
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
        },
      );
    }
  }

  void connect() {
    if (_socket != null) {
      _socket!.connect();
    }
  }

  void listenToConnectionEvent() {
    if (_socket != null) {
      _socket!.on(
        'connect',
        (_) => print('connected to Socket: ${_socket!.id}'),
      );
    }
  }

  void disconnect() {
    if (_socket != null) {
      _socket!.disconnect();
    }
  }

  void emit(String event, dynamic data) {
    if (_socket != null) {
      _socket!.emit(event, data);
    }
  }

  void on(String event, Function(dynamic) callback) {
    if (_socket != null) {
      _socket!.on(event, callback);
    }
  }
}
