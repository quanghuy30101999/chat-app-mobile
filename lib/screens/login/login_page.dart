import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/screens/login/components/body.dart';
import 'package:chat_app/screens/login/components/header.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLogin = SharedPreferencesService.isLogin();
  @override
  Widget build(BuildContext context) {
    if (isLogin) return HomePage();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Header(),
              Body(
                formKey: _formKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
