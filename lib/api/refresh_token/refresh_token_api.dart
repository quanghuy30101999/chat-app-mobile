import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RefreshTokenApi {
  static const baseUrl = 'https://chatapp24.com/api/v1/';
  static const endpoint = 'refresh-token';

  static Future<void> refreshToken({
    Function(String token, String refreshToken)? onSuccess,
    Function(String? message)? onError,
  }) async {
    try {
      var response = await http.post(Uri.parse(baseUrl + endpoint),
          body: {"refresh_token": SharedPreferencesService.readRefreshToken()});
      if (response.statusCode < 400) {
        var data = json.decode(response.body)["data"];
        onSuccess?.call(data['token'], data['refresh_token']);
      } else {
        onError?.call(json.decode(response.body)["error"]["message"]);
      }
    } catch (error) {
      onError?.call(error.toString());
    }
  }
}
