import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MessageDetail extends StatelessWidget {
  Message message;
  MessageDetail({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment:
            (message.userId != SharedPreferencesService.readUserData()!.id
                ? Alignment.topLeft
                : Alignment.topRight),
        child: AnimatedContainer(
          onEnd: () {},
          duration: const Duration(milliseconds: 500),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.transparent,
              width: 5.0,
            ),
            borderRadius: BorderRadius.circular(20),
            color:
                (message.userId != SharedPreferencesService.readUserData()!.id
                    ? Colors.grey.shade200
                    : Colors.blue[200]),
          ),
          padding: const EdgeInsets.all(16),
          child: Text(
            message.text ?? '',
            style: const TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}
