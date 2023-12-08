import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserList extends StatefulWidget {
  User user;
  UserList({super.key, required this.user});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.user.avatarUrl ?? ''),
                maxRadius: 30,
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                widget.user.username,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(left: 75, right: 20),
            child: Divider(),
          )
        ],
      ),
    );
  }
}
