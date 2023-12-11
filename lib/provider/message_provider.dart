import 'package:chat_app/api/messageApi/message_api.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/foundation.dart';

class MessageProvider with ChangeNotifier {
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  Future<void> getMessage({required String conversationId}) async {
    MessageApi messageApi = MessageApi();
    messageApi.getMessages(
        conversationId: conversationId,
        onSuccess: (messages) {
          _messages = messages;
          notifyListeners();
        },
        onError: (error) {
          print(error);
        });
  }

  Future<void> postMessage(
      {required String conversationId,
      required String text,
      Function? onSuccess}) async {
    MessageApi messageApi = MessageApi();
    await messageApi.postMessage(
        text: text,
        conversationId: conversationId,
        onSuccess: (message) {
          _messages.add(message);
          notifyListeners();
          onSuccess?.call();
        },
        onError: (error) {
          print(error);
        });
  }
}
