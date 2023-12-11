import 'package:chat_app/api/%1CauthApi/auth_api.dart';
import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConversationApi extends AuthApiService {
  Future<void> getConversations(
      {Function(List<Conversation>)? onSuccess,
      Function(String? message)? onError}) async {
    User? user = SharedPreferencesService.readUserData();
    String endpoint = "users/${user!.id}/conversations";
    try {
      var response =
          await http.get(Uri.parse(baseUrl + endpoint), headers: headers);
      if (response.statusCode < 400) {
        List<dynamic> data = json.decode(response.body)["data"];

        List<Conversation> conversations =
            data.map((x) => Conversation.fromJson(x)).toList();
        onSuccess?.call(conversations);
      } else {
        onError?.call(json.decode(response.body)["error"]["message"]);
      }
    } catch (error) {
      onError?.call(error.toString());
    }
  }
}
