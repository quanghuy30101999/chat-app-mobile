// conversation_logic.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/provider/conversation_provider.dart';

class ConversationLogic {
  final BuildContext context;
  bool isFocus = false;

  ConversationLogic({required this.context});

  void onChange(String? text) {
    if (text != null) {
      Provider.of<ConversationProVider>(context, listen: false)
          .getUsers(text: text);
    }
  }

  void handleGestureTap() {
    FocusScope.of(context).unfocus();
  }
}
