import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UsersInfoDisplay extends StatelessWidget {
  List<User> users;
  UsersInfoDisplay({super.key, required this.users});

  String showNameGroup() {
    return users.map((e) => e.username).reduce((value, element) {
      return "${value.split(" ").last}, ${element.split(" ").last}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          showNameGroup(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 6,
        ),
      ],
    );
  }
}
