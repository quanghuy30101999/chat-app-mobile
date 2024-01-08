import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Avatar extends StatelessWidget {
  String? avatarUrl;
  Avatar({super.key, required this.avatarUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: AssetImage('assets/images/avatar.png'),
      //  NetworkImage(avatarUrl ??
      //     "https://i.pinimg.com/736x/40/0e/b8/400eb8a3081a741b593f12591ac40036.jpg"),
      maxRadius: 20,
    );
  }
}
