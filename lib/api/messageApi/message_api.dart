import 'dart:io';

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

  Future<Message?> postMessage(
      {required String conversationId,
      String? text,
      File? imagePath,
      Function(Message)? onSuccess,
      Function(String? message)? onError}) async {
    String endpoint = "conversations/$conversationId/messages";
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(baseUrl + endpoint),
    );
    if (headers != null && headers!['Authorization'] != null) {
      request.headers['Authorization'] = headers!['Authorization']!;
    }

    if (text != null) {
      request.fields['text'] = text;
    }
    if (imagePath != null) {
      request.files.add(
        await http.MultipartFile.fromPath('media_url', imagePath.path),
      );
    }

    try {
      var response = await request.send();
      if (response.statusCode < 400) {
        var responseBody = await response.stream.bytesToString();
        Message message = Message.fromJson(json.decode(responseBody)['data']);
        // onSuccess?.call(message);
        return message;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
    return null;
  }

  Future<Message?> forwardMessage({
    required String conversationId,
    required String messageId,
  }) async {
    try {
      String endpoint = "conversations/$conversationId/messages/$messageId";
      var response =
          await http.post(Uri.parse(baseUrl + endpoint), headers: headers);
      if (response.statusCode < 400) {
        dynamic data = json.decode(response.body)["data"];
        Message message = Message.fromJson(data);
        return message;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
