import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Avatars extends StatelessWidget {
  List<User> users;
  double radius;

  Avatars({required this.users, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Hình tròn lớn
        CircleAvatar(
          radius: radius, // Đường kính của hình tròn lớn
          backgroundColor: Colors.white, // Màu nền của hình tròn lớn
        ),
        // Avatar nhỏ 1
        const Positioned(
          left: 20,
          child: CircleAvatar(
            radius: 20, // Đường kính của avatar nhỏ
            backgroundImage: AssetImage('assets/images/avatar.png'),
            //  NetworkImage(users[0].avatarUrl ??
            //     "https://i.pinimg.com/736x/40/0e/b8/400eb8a3081a741b593f12591ac40036.jpg"),
          ),
        ),
        // Avatar nhỏ 2
        Positioned(
          top: 20,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xff7c94b6),
              image: const DecorationImage(
                image: AssetImage('assets/images/avatar.png'),
                // NetworkImage(users[1].avatarUrl ??
                //     'https://i.pinimg.com/736x/40/0e/b8/400eb8a3081a741b593f12591ac40036.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(50.0)),
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
        showStatus()
      ],
    );
  }

  Widget showStatus() {
    if (users.any((element) => element.isOnline == true)) {
      return Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      );
    }
    return Container();
  }
}
