import 'package:chat_app/api/%1CauthApi/auth_api.dart';
import 'package:chat_app/models/message.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MessageApi extends AuthApiService {
  Future<void> getMessages(
      {required String conversationId,
      Function(List<Message>)? onSuccess,
      Function(String? message)? onError}) async {
    String endpoint = "conversations/$conversationId/messages";
    try {
      var response =
          await http.get(Uri.parse(baseUrl + endpoint), headers: headers);
      if (response.statusCode < 400) {
        List<dynamic> data = json.decode(response.body)["data"];

        List<Message> messages = data.map((x) => Message.fromJson(x)).toList();
        onSuccess?.call(messages);
      } else {
        onError?.call(json.decode(response.body)["error"]["message"]);
      }
    } catch (error) {
      onError?.call(error.toString());
    }
  }

  Future<void> postMessage(
      {required String conversationId,
      required String text,
      Function(Message)? onSuccess,
      Function(String? message)? onError}) async {
    String endpoint = "conversations/$conversationId/messages";
    try {
      var response = await http.post(Uri.parse(baseUrl + endpoint),
          headers: headers, body: {'text': text});
      if (response.statusCode < 400) {
        var data = json.decode(response.body)["data"];

        Message message = Message.fromJson(data);
        onSuccess?.call(message);
      } else {
        onError?.call(json.decode(response.body)["error"]["message"]);
      }
    } catch (error) {
      onError?.call(error.toString());
    }
  }
}
