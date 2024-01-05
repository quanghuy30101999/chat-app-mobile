import 'package:chat_app/api/conversationApi/conversation_api.dart';
import 'package:chat_app/helpers/socket_manager.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/foundation.dart';

class ConversationProVider with ChangeNotifier {
  List<Conversation> _conversationsAll = [];
  List<Conversation> _conversations = [];
  List<Conversation> _groups = [];
  List<Conversation> _users = [];

  List<Conversation> get conversations => _conversations;
  List<Conversation> get users => _users;
  List<Conversation> get groups => _groups;
  List<Conversation> get conversationsAll => _conversationsAll;

  Future<void> getConversations(
      {Function(List<Conversation>)? onSuccess,
      Function(String? message)? onError}) async {
    ConversationApi conversationApi = ConversationApi();
    await conversationApi.getConversations(
        onSuccess: (conversations) {
          _conversationsAll = conversations;
          for (var element in _conversationsAll) {
            element.messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          }
          _conversations = _conversationsAll
              .where((element) =>
                  element.messages.isNotEmpty && element.isGroup() == false)
              .toList();
          _groups =
              _conversationsAll.where((element) => element.isGroup()).toList();
          onSuccess?.call(_conversationsAll);
          sortConversations();
          sortGroup();
          notifyListeners();
        },
        onError: (message) => onError?.call(message));
  }

  void updateMessage(String conversationId, Message oldMessage) {
    Conversation a;
    try {
      a = _conversations.firstWhere((element) => element.id == conversationId);
    } catch (e) {
      a = _groups.firstWhere((element) => element.id == conversationId);
    }
    a.messages.removeWhere((element) => element.id == oldMessage.id);
  }

  void deleteMessageTyping(String conversationId, String userId) {
    Conversation a;
    try {
      a = _conversations.firstWhere((element) => element.id == conversationId);
      sortConversations();
    } catch (e) {
      a = _groups.firstWhere((element) => element.id == conversationId);
    }
    a.messages.removeWhere((element) => element.isTyping == true);
    sortConversations();
    sortGroup();
    notifyListeners();
  }

  Future<void> createGroup({
    required String name,
    required List<String> userIds,
  }) async {
    ConversationApi conversationApi = ConversationApi();
    var conversation =
        await conversationApi.createGroup(name: name, userIds: userIds);
    if (conversation != null) {
      _groups.add(conversation);
      SocketManager().emitEvent('join_group', conversation.id);
      sortGroup();
      notifyListeners();
    }
  }

  void deleteGroup({required String conversationId}) {
    ConversationApi conversationApi = ConversationApi();
    conversationApi.deleteGroup(conversationId: conversationId);
  }

  void deleteFromSocket({required String conversationId}) {
    _groups.removeWhere((element) => element.id == conversationId);
    notifyListeners();
  }

  void addGroup(Conversation conversation) {
    _groups.add(conversation);
    sortGroup();
    notifyListeners();
  }

  void sortConversations() {
    _conversations.sort((a, b) =>
        lastMessage(b)!.createdAt.compareTo(lastMessage(a)!.createdAt));
  }

  void sortGroup() {
    _groups.sort((a, b) {
      if (lastMessage(b) == null && lastMessage(a) == null) {
        return 0;
      } else if (lastMessage(a) == null) {
        return 1;
      } else if (lastMessage(b) == null) {
        return -1;
      }
      return lastMessage(b)!.createdAt.compareTo(lastMessage(a)!.createdAt);
    });
  }

  Message? lastMessage(Conversation conversation) {
    if (conversation.messages.isEmpty) return null;
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
        if (!element.isGroup()) _conversations.add(element);
        sortGroup();
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
    for (var group in _groups) {
      if (conversationIds.contains(group.id)) {
        User? user;
        try {
          user = group.users.firstWhere((user) => user.id == userId);
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
      int i = _groups.indexWhere((element) => element.id == conversationId);
      if (i != -1) {
        int indexUser =
            _groups[i].users.indexWhere((element) => element.id == user.id);
        if (indexUser != -1) {
          _groups[i].users[indexUser] = user;
          notifyListeners();
        } else {
          print('User not found in group list');
        }
      }
    }
  }

  void clearData() {
    _conversationsAll = [];
    _conversations = [];
    _users = [];
    _groups = [];
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

  void allUser() {
    _users = _conversationsAll
        .where((element) => element.isGroup() == false)
        .toList();
  }
}
