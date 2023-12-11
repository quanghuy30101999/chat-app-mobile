import 'dart:convert';

import 'package:chat_app/api/refresh_token/refresh_token_api.dart';
import 'package:chat_app/helpers/shared_preferences.dart';

class TokenManager {
  static Future<void> getAccessToken() async {
    String? accessToken = SharedPreferencesService.readTokenUser();
    String? refreshToken = SharedPreferencesService.readTokenUser();
    if (refreshToken == null) return;
    if (accessToken == null) return;
    bool shouldRefresh =
        isTokenExpired(accessToken) && isTokenExpired(refreshToken);
    if (shouldRefresh) await refreshAccessToken();
  }

  static Future<void> refreshAccessToken() async {
    await RefreshTokenApi.refreshToken(
        onSuccess: (token, refreshToken) {
          SharedPreferencesService.setRefreshToken(token, refreshToken);
        },
        onError: (_) {});
  }

  static bool isTokenExpired(String token) {
    int? expirationTimeInSeconds = getExpirationTimeFromToken(token);

    if (expirationTimeInSeconds == null) return false;
    int currentTimeInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    int threshold = 500;

    if (expirationTimeInSeconds <= currentTimeInSeconds) {
      return true;
    } else if ((expirationTimeInSeconds - currentTimeInSeconds) <= threshold) {
      return true;
    }
    return false;
  }

  static int? getExpirationTimeFromToken(String accessToken) {
    List<String> tokenParts = accessToken.split('.');

    String payload = tokenParts.length > 1 ? tokenParts[1] : '';

    String decodedPayload =
        String.fromCharCodes(base64Url.decode(base64Url.normalize(payload)));

    Map<String, dynamic> payloadData = json.decode(decodedPayload);

    if (payloadData.containsKey('exp')) {
      return payloadData['exp'];
    }
    return null;
  }
}
