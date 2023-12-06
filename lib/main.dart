import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/provider/loading_provider.dart';
import 'package:chat_app/provider/login_provider.dart';
import 'package:chat_app/screens/login/login.dart';
import 'package:chat_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(const MyApp());
  await SharedPreferencesService.init();
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
      ],
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: LoadingWidget(
          key: key,
          child: Login(key: key),
        ),
      ),
    );
  }
}
