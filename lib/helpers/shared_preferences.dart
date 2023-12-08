import 'package:chat_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SharedPreferencesService {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveUserData(
      String token, String refreshToken, String user) async {
    await _preferences.setString('token', token);
    await _preferences.setString('refresh_token', refreshToken);
    await _preferences.setString('user', user);
  }

  static String? readTokenUser() {
    String? token = _preferences.getString('token');
    return token;
  }

  static String? readRefreshToken() {
    String? refreshToken = _preferences.getString('refresh_token');
    return refreshToken;
  }

  static Future<User> readUserData() async {
    User? user =
        User.fromJson(json.decode(_preferences.getString('user') ?? ''));

    return user;
  }

  static Future<void> setRefreshToken(String token, String refreshToken) async {
    await _preferences.setString('token', token);
    await _preferences.setString('refresh_token', refreshToken);
  }

  static bool isLogin() {
    String? data = _preferences.getString('user');
    if (data != null) {
      return true;
    }
    return false;
  }

  static Future<void> clearUserData() async {
    await _preferences.remove('user');
    await _preferences.remove('token');
    await _preferences.remove('refresh_token');
  }
}
