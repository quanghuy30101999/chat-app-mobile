import 'dart:io';

import 'package:chat_app/api/messageApi/message_api.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/foundation.dart';

class MessageProvider with ChangeNotifier {
  void updateDataFromSocket() {
    notifyListeners();
  }

  Future<void> postMessage(
      {required String conversationId,
      String? text,
      File? imagePath,
      Function(Message?)? onSuccess,
      Function? onError}) async {
    MessageApi messageApi = MessageApi();
    messageApi
        .postMessage(
            text: text,
            imagePath: null,
            conversationId: conversationId,
            onSuccess: (message) {},
            onError: (error) {
              onError?.call();
            })
        .then((message) {
      onSuccess?.call(message);
      notifyListeners();
    });
  }

  void sendImage(
      {required String conversationId,
      String? text,
      File? imagePath,
      Function(Message)? onSuccess,
      Function? onError}) {
    MessageApi messageApi = MessageApi();
    messageApi
        .postMessage(
      text: null,
      imagePath: imagePath,
      conversationId: conversationId,
    )
        .then((message) {
      if (message != null) {
        onSuccess?.call(message);
      }
    });
  }
}
