import 'package:chat_app/api/api_service.dart';
import 'package:chat_app/helpers/shared_preferences.dart';

class AuthApiService extends ApiService {
  Map<String, String>? headers = {
    'Authorization': SharedPreferencesService.readTokenUser().toString(),
  };
}
