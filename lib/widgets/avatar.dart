import 'package:chat_app/models/user.dart';
import 'package:chat_app/widgets/timer_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Avatar extends StatelessWidget {
  User user;
  double radius;

  Avatar({required this.user, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          backgroundImage: const AssetImage('assets/images/avatar.png'),
          maxRadius: radius,
        ),
        showStatus(user)
      ],
    );
  }

  Widget showStatus(User user) {
    if (user.isOnline) {
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
    if (user.lastActive == null) return Container();
    DateTime? lastActive = user.lastActive!;
    return TimerWidget(lastActive: lastActive);
  }
}
