import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UserList extends StatefulWidget {
  List<User> users;
  UserList({super.key, required this.users});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          SizedBox(
            height: 80,
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.users.length < 3
                  ? widget.users[0].avatarUrl ??
                      'https://i.pinimg.com/736x/40/0e/b8/400eb8a3081a741b593f12591ac40036.jpg'
                  : ''),
              radius: 30,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 49,
                    child: Text(
                      widget.users
                          .map((e) => e.username)
                          .reduce((value, element) {
                        return "${value.split(" ").last}, ${element.split(" ").last}";
                      }),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 1,
                    child: Divider(
                      height: 1,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
