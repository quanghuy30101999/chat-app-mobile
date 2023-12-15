// conversation_logic.dart

import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/helpers/socket_manager.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import '../../models/user.dart';

class ConversationLogic {
  final BuildContext context;
  bool isFocus = false;

  ConversationLogic({
    required this.context,
  });

  void initSocketListeners() {
    SocketManager().listenToEvent('receive_message', (data) {
      Message message = Message.fromJson(data);
      try {
        Provider.of<ConversationProVider>(context, listen: false)
            .setLastMessage(
          conversationId: message.conversationId,
          message: message,
        );
      } catch (e) {
        print(e);
      }
    });

    SocketManager().listenToEvent('update_online_status', (data) {
      Provider.of<ConversationProVider>(context, listen: false)
          .updateStatusOnline(
              conversationIds: data['conversationIds'].cast<String>(),
              userId: data['userId']);
    });

    SocketManager().listenToEvent('user_disconnect', (data) {
      Provider.of<ConversationProVider>(context, listen: false)
          .updateUserOffline(
              data['conversationId'], User.fromJson(data['user']));
    });
  }

  void onChange(String? text) {
    if (text != null) {
      Provider.of<ConversationProVider>(context, listen: false)
          .getUsers(text: text);
    }
  }

  void handleGestureTap(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
