import 'package:chat_app/api/loginApi/login_api.dart';
import 'package:flutter/foundation.dart';

class LoginProvider with ChangeNotifier {
  Future<void> login(
      {required String userId,
      Function? onSuccess,
      Function(String? message)? onError}) async {
    LoginApi loginApi = LoginApi();
    await loginApi.loginApi(
        userId: userId,
        onSuccess: () => onSuccess?.call(),
        onError: (message) => onError?.call(message));
  }
}
