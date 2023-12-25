import 'package:chat_app/helpers/constants.dart';
import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();

  factory SocketManager() {
    return _instance;
  }

  SocketManager._internal();

  io.Socket? _socket;

  void connectToServer() {
    String token = SharedPreferencesService.readTokenUser() ?? '';
    _socket = io.io(Constants.url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'token': token}
    });

    _socket!.connect();

    _socket?.on('connect', (_) {
      print('Connected to server');
    });

    listenToEvent('error', (error) {
      print(error);
    });
  }

  void listenToEvent(String eventName, Function(dynamic) callback) {
    _socket?.on(eventName, callback);
  }

  void emitEvent(String eventName, dynamic data) {
    _socket?.emit(eventName, data);
  }

  void closeConnection() {
    _socket?.disconnect();
  }
}
