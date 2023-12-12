import 'package:chat_app/api/conversationApi/conversation_api.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/foundation.dart';

class ConversationProVider with ChangeNotifier {
  List<Conversation> _conversationsAll = [];
  List<Conversation> _conversations = [];
  List<Conversation> _users = [];

  List<Conversation> get conversations => _conversations;
  List<Conversation> get users => _users;
  List<Conversation> get conversationsAll => _conversationsAll;

  Future<void> getConversations(
      {Function? onSuccess, Function(String? message)? onError}) async {
    ConversationApi conversationApi = ConversationApi();
    await conversationApi.getConversations(
        onSuccess: (conversations) {
          _conversationsAll = conversations;
          _conversations = _conversationsAll
              .where((element) => element.messages.isNotEmpty)
              .toList();
          sortConversations();
          notifyListeners();
        },
        onError: (message) => onError?.call(message));
  }

  void sortConversations() {
    _conversations.sort(
        (a, b) => lastMessage(b).createdAt.compareTo(lastMessage(a).createdAt));
  }

  Message lastMessage(Conversation conversation) {
    return conversation.messages[conversation.messages.length - 1];
  }

  void setLastMessage(
      {required Conversation conversation, required Message message}) {
    _conversations
        .firstWhere((e) => e.id == conversation.id)
        .messages
        .add(message);
    sortConversations();
    notifyListeners();
  }

  void getUsers({String? text}) {
    if (text != null && text != "") {
      _users = _conversationsAll
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
