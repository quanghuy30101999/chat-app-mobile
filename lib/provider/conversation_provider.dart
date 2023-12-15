import 'package:chat_app/api/conversationApi/conversation_api.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/foundation.dart';

class ConversationProVider with ChangeNotifier {
  List<Conversation> _conversationsAll = [];
  List<Conversation> _conversations = [];
  List<Conversation> _users = [];

  List<Conversation> get conversations => _conversations;
  List<Conversation> get users => _users;
  List<Conversation> get conversationsAll => _conversationsAll;

  Future<void> getConversations(
      {Function(List<Conversation>)? onSuccess,
      Function(String? message)? onError}) async {
    ConversationApi conversationApi = ConversationApi();
    await conversationApi.getConversations(
        onSuccess: (conversations) {
          _conversationsAll = conversations;
          _conversations = _conversationsAll
              .where((element) =>
                  element.messages.isNotEmpty && element.isGroup() == false)
              .toList();

          onSuccess?.call(_conversationsAll);
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

  void setLastMessage({
    required String conversationId,
    required Message message,
  }) {
    try {
      _conversations
          .firstWhere((e) => e.id == conversationId)
          .messages
          .add(message);
    } catch (e) {
      try {
        Conversation? element =
            _conversationsAll.firstWhere((e) => e.id == conversationId);
        element.messages.add(message);
        _conversations.add(element);
      } catch (e) {
        print(e);
      }
    }
    sortConversations();
    notifyListeners();
  }

  void updateStatusOnline(
      {required List<String> conversationIds, required String userId}) {
    for (var conversation in _conversations) {
      if (conversationIds.contains(conversation.id)) {
        User? user;
        try {
          user = conversation.users.firstWhere((user) => user.id == userId);
        } catch (e) {
          user = null;
        }
        if (user != null) user.isOnline = true;
      }
    }
    notifyListeners();
  }

  void updateUserOffline(String conversationId, User user) {
    int index =
        _conversations.indexWhere((element) => element.id == conversationId);
    if (index != -1) {
      int indexUser = _conversations[index]
          .users
          .indexWhere((element) => element.id == user.id);
      if (indexUser != -1) {
        _conversations[index].users[indexUser] = user;
        notifyListeners();
      } else {
        print('User not found in conversation users list');
      }
    } else {
      print('Conversation not found');
    }
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
