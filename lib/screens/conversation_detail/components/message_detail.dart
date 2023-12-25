import 'package:cached_network_image/cached_network_image.dart';
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
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
      child: Align(
        alignment:
            (message.userId != SharedPreferencesService.readUserData()!.id
                ? Alignment.topLeft
                : Alignment.topRight),
        child: Container(
          decoration: showDecoration(),
          padding: padding(),
          child: Column(
            children: [
              if (message.text != null)
                Text(
                  message.text ?? '',
                  style: const TextStyle(fontSize: 15),
                ),
              image(context)
            ],
          ),
        ),
      ),
    );
  }

  EdgeInsetsGeometry padding() {
    if (message.mediaUrl != null || message.asset != null) {
      return const EdgeInsets.symmetric(vertical: 0, horizontal: 0);
    }
    return const EdgeInsets.symmetric(vertical: 10, horizontal: 10);
  }

  Decoration? showDecoration() {
    if (message.mediaUrl != null || message.asset != null) {
      return null;
    }
    return BoxDecoration(
        border: Border.all(color: Colors.transparent, width: 5),
        borderRadius: BorderRadius.circular(20),
        color: xxx());
  }

  Widget image(BuildContext context) {
    if (message.mediaUrl != null) {
      return SizedBox(
          height: 400,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: message.mediaUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const CircularProgressIndicator(color: Colors.transparent),
              // errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ));
    }
    if (message.asset != null) {
      return SizedBox(
        height: 400,
        width: MediaQuery.sizeOf(context).width,
        child: AssetEntityImageScreen(asset: message.asset!),
      );
    }
    return const SizedBox(
      height: 0,
      width: 0,
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
