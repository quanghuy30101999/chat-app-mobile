import 'dart:async';

class EventBus {
  factory EventBus() => _instance;

  EventBus._private();

  static final EventBus _instance = EventBus._private();

  Map<String, StreamController<dynamic>> _events = {};

  Stream<dynamic> on(String eventName) {
    _events[eventName] ??= StreamController.broadcast();
    return _events[eventName]!.stream;
  }

  void emit(String eventName, [dynamic data]) {
    _events[eventName]?.add(data);
  }

  void destroy(String eventName) {
    _events[eventName]?.close();
    _events.remove(eventName);
  }
}
