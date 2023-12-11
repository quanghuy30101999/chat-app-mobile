import 'package:chat_app/api/api_service.dart';
import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginApi extends ApiService {
  Future<void> loginApi(
      {required String userId,
      Function? onSuccess,
      Function(String? message)? onError}) async {
    String endpoint = "login";
    try {
      var response =
          await http.post(Uri.parse(baseUrl + endpoint), body: {"id": userId});
      if (response.statusCode < 400) {
        var data = json.decode(response.body)["data"];
        await SharedPreferencesService.saveUserData(
            data['token'], data['refresh_token'], jsonEncode(data['user']));
        onSuccess?.call();
      } else {
        onError?.call(json.decode(response.body)["error"]["message"]);
      }
    } catch (error) {
      onError?.call(error.toString());
    }
  }
}
