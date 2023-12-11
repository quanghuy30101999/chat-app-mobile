import 'package:chat_app/api/conversationApi/conversation_api.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:flutter/foundation.dart';

class ConversationProVider with ChangeNotifier {
  List<Conversation> _conversations = [];
  List<Conversation> _users = [];

  List<Conversation> get conversations => _conversations;
  List<Conversation> get users => _users;

  Future<void> getConversations(
      {Function? onSuccess, Function(String? message)? onError}) async {
    ConversationApi conversationApi = ConversationApi();
    await conversationApi.getConversations(
        onSuccess: (conversations) {
          _conversations = conversations;
          notifyListeners();
        },
        onError: (message) => onError?.call(message));
  }

  void getUsers({String? text}) {
    if (text != null && text != "") {
      _users = _conversations
          .where((element) => element.users[0].username
              .toLowerCase()
              .contains(text.toLowerCase().trim()))
          .toList();
    } else {
      _users = [];
    }

    notifyListeners();
  }
}
