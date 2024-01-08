import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Trang cá nhân'),
        ),
        body: ProfileBody(),
      ),
    );
  }
}

// ignore: must_be_immutable
class ProfileBody extends StatelessWidget {
  var user = SharedPreferencesService.readUserData();

  ProfileBody({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: <Widget>[
        const SizedBox(height: 20.0),
        const Center(
          child: CircleAvatar(
            radius: 50.0,
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
        ),
        const SizedBox(height: 20.0),
        Text(
          user!.username,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10.0),
        const ListTile(
          leading: Icon(Icons.email),
          title: Text('email@example.com'),
        ),
        const ListTile(
          leading: Icon(Icons.phone),
          title: Text('+1 123-456-7890'),
        ),
        const ListTile(
          leading: Icon(Icons.location_on),
          title: Text('New York, USA'),
        ),
      ],
    );
  }
}
