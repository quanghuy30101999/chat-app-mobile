import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/helpers/firebase_messaging_service.dart';
import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/helpers/token_manager.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/provider/loading_provider.dart';
import 'package:chat_app/provider/login_provider.dart';
import 'package:chat_app/provider/message_provider.dart';
import 'package:chat_app/screens/login/login_page.dart';
import 'package:chat_app/widgets/loading_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPreferencesService.init();
  await TokenManager.getAccessToken();
  await FirebaseMessagingService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoadingProvider>(
            create: (_) => LoadingProvider()),
        ChangeNotifierProvider<LoginProvider>(create: (_) => LoginProvider()),
        ChangeNotifierProvider<ConversationProVider>(
            create: (_) => ConversationProVider()),
        ChangeNotifierProvider<MessageProvider>(
            create: (_) => MessageProvider()),
      ],
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: LoadingWidget(
          key: key,
          child: LoginPage(key: key),
        ),
      ),
    );
  }
}
