import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helpers/date_formats.dart';
import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/conversation/components/typing_indicator.dart';
import 'package:chat_app/screens/conversation_detail/components/asset_entity_image_screen.dart';
import 'package:chat_app/screens/conversation_detail/components/forward_message.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MessageDetail extends StatefulWidget {
  Message message;
  MessageDetail({super.key, required this.message});

  @override
  State<MessageDetail> createState() => _MessageDetailState();
}

class _MessageDetailState extends State<MessageDetail> {
  bool isShowTime = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    isShowTime = false;
  }

  @override
  Widget build(BuildContext context) {
    return isShowTime
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(DateFormats.formatDateTime(widget.message.createdAt)),
                  ],
                ),
              ),
              message(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                child: Text('Đã xem'),
              )
            ],
          )
        : message();
  }

  Widget message() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 14),
      child: Align(
        alignment: getMessageAlignment(),
        child: GestureDetector(
          onTap: onTapMessage,
          child: Row(
            mainAxisAlignment: getMessageMainAxisAlignment(),
            children: [
              if (shouldShowFavoriteIcon()) ...[replyIcon()],
              messageContent(),
              if (!shouldShowFavoriteIcon()) ...[
                const SizedBox(
                  width: 10,
                ),
                favoriteIcon()
              ],
            ],
          ),
        ),
      ),
    );
  }

  Alignment getMessageAlignment() {
    return (widget.message.userId != SharedPreferencesService.readUserData()?.id
        ? Alignment.topLeft
        : Alignment.topRight);
  }

  MainAxisAlignment getMessageMainAxisAlignment() {
    return (widget.message.userId != SharedPreferencesService.readUserData()?.id
        ? MainAxisAlignment.start
        : MainAxisAlignment.end);
  }

  void forwardMessage() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _buildBottomSheetContent()!; // Hiển thị bottom sheet khi nhấn nút
      },
    );
  }

  Widget? _buildBottomSheetContent() {
    return ForwardMessage(
      message: widget.message,
    );
  }

  Widget favoriteIcon() {
    return GestureDetector(
      onTap: forwardMessage,
      child: const Icon(
        Icons.forward,
        size: 30,
        color: Colors.grey,
      ),
    );
  }

  Widget replyIcon() {
    return GestureDetector(
      onTap: forwardMessage,
      child: const Icon(
        Icons.reply,
        size: 30,
        color: Colors.grey,
      ),
    );
  }

  Widget messageContent() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: showDecoration(),
      padding: padding(),
      child: (widget.message.isTyping != null && widget.message.isTyping!)
          ? const TypingIndicator()
          : Column(
              children: [
                if (widget.message.text != null)
                  Text(
                    widget.message.text ?? '',
                    style: const TextStyle(fontSize: 15),
                  ),
                image(context), // Nếu có hàm image() để hiển thị hình ảnh
              ],
            ),
    );
  }

  bool shouldShowFavoriteIcon() {
    return widget.message.userId == SharedPreferencesService.readUserData()?.id;
  }

  void onTapMessage() {
    if (widget.message.text != null) {
      setState(() {
        isShowTime = !isShowTime;
      });
    }
  }

  EdgeInsetsGeometry padding() {
    if (widget.message.mediaUrl != null || widget.message.asset != null) {
      return const EdgeInsets.symmetric(vertical: 0, horizontal: 0);
    }
    return const EdgeInsets.symmetric(vertical: 10, horizontal: 10);
  }

  Decoration? showDecoration() {
    if (widget.message.mediaUrl != null || widget.message.asset != null) {
      return null;
    }
    return BoxDecoration(
        border: Border.all(color: Colors.transparent, width: 5),
        borderRadius: BorderRadius.circular(20),
        color: xxx());
  }

  Widget image(BuildContext context) {
    if (widget.message.mediaUrl != null) {
      return Container(
        constraints: const BoxConstraints(
          maxHeight: 400.0,
          maxWidth: 300.0,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: CachedNetworkImage(
            filterQuality: FilterQuality.low,
            imageUrl: widget.message.mediaUrl!,
            fit: BoxFit.fill,
            placeholder: (context, url) => const CircularProgressIndicator(),
            // errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      );
    }
    if (widget.message.asset != null) {
      return IntrinsicWidth(
        child: IntrinsicHeight(
          child: Container(
            alignment: Alignment.topRight,
            child: AssetEntityImageScreen(asset: widget.message.asset!),
          ),
        ),
      );
    }
    return const SizedBox(
      height: 0,
      width: 0,
    );
  }

  Color? xxx() {
    if (widget.message.asset != null || widget.message.mediaUrl != null) {
      return Colors.transparent;
    }
    if (widget.message.userId != SharedPreferencesService.readUserData()!.id) {
      return Colors.grey.shade200;
    }
    return Colors.blue[200];
  }
}
