import 'package:chat_app/api/messageApi/message_api.dart';
import 'package:flutter/foundation.dart';

class MessageProvider with ChangeNotifier {
  void updateDataFromSocket() {
    notifyListeners();
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
          notifyListeners();
          onSuccess?.call();
        },
        onError: (error) {
          print(error);
        });
  }
}
