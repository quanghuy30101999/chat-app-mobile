import 'package:chat_app/api/conversationApi/conversation_api.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:flutter/foundation.dart';

class ConversationProVider with ChangeNotifier {
  List<Conversation> _conversations = [];

  List<Conversation> get conversations => _conversations;
  Future<void> getConversations(
      {Function? onSuccess, Function(String? message)? onError}) async {
    ConversationApi conversationApi = ConversationApi();
    await conversationApi.getConversations(
        onSuccess: (conversations) {
          conversations = conversations
              .where((element) => element.lastMessage != null)
              .toList();
          _conversations = conversations;
          notifyListeners();
        },
        onError: (message) => onError?.call(message));
  }
}
