import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> saveUserData(String token, String user) async {
    await _preferences.setString('token', token);
    await _preferences.setString('user', user);
  }

  static String? readTokenUser() {
    String? token = _preferences.getString('token');
    return token;
  }

  static Future<Map<String, String>> readUserData() async {
    String? username = _preferences.getString('username');
    String? email = _preferences.getString('email');

    return {'username': username ?? '', 'email': email ?? ''};
  }

  static Future<void> clearUserData() async {
    await _preferences.remove('username');
    await _preferences.remove('email');
  }
}
