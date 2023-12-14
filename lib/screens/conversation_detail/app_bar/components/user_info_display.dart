import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserInfoDisplay extends StatelessWidget {
  User user;
  UserInfoDisplay({super.key, required this.user});

  String status(bool isOnline) {
    if (isOnline) return 'Đang hoạt động';
    DateTime? lastActive = user.lastActive!;
    DateTime now = DateTime.now();
    Duration difference = now.difference(lastActive);

    int seconds = difference.inSeconds;
    int minutes = difference.inMinutes;
    int hours = difference.inHours;
    int days = difference.inDays;

    String timeDifferenceText = '';

    if (days > 0) {
      timeDifferenceText = "$days ngày";
    } else if (hours > 0) {
      timeDifferenceText = '$hours giờ';
    } else if (minutes > 0) {
      timeDifferenceText = '$minutes phút';
    } else {
      timeDifferenceText = '$seconds giây';
    }

    return "Hoạt động $timeDifferenceText trước";
  }

  Widget showStatus(bool isOnline) {
    if (isOnline) {
      return Text(
        status(user.isOnline),
        style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
      );
    }
    if (user.lastActive == null) return Container();
    return Text(
      status(user.isOnline),
      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          user.username,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 6,
        ),
        showStatus(user.isOnline),
      ],
    );
  }
}
