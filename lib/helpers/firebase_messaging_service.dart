import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  static late FirebaseMessaging _firebaseMessaging;

  static Future<void> init() async {
    try {
      _firebaseMessaging = FirebaseMessaging.instance;
      await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      String? fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        SharedPreferencesService.setFcmToken(fcmToken);
      }
    } catch (e) {
      print(e);
    }
  }
}
