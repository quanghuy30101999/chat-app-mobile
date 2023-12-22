import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/conversation_detail/components/asset_entity_image_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MessageDetail extends StatelessWidget {
  Message message;
  MessageDetail({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 2, bottom: 2),
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
              color: xxx()),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (message.text != null)
                Text(
                  message.text ?? '',
                  style: const TextStyle(fontSize: 15),
                ),
              if (message.asset != null)
                SizedBox(
                  height: 300,
                  child: AssetEntityImageScreen(asset: message.asset!),
                )
            ],
          ),
        ),
      ),
    );
  }

  Color? xxx() {
    if (message.asset != null || message.mediaUrl != null) {
      return Colors.transparent;
    }
    if (message.userId != SharedPreferencesService.readUserData()!.id) {
      return Colors.grey.shade200;
    }
    return Colors.blue[200];
  }
}
