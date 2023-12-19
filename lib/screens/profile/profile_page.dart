import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/helpers/socket_manager.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/screens/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            SharedPreferencesService.clearUserData();
            SocketManager().closeConnection();
            Provider.of<ConversationProVider>(context, listen: false)
                .clearData();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text('Logout')),
    );
  }
}
