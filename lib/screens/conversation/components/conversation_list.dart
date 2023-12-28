import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/helpers/socket_manager.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/provider/message_provider.dart';
import 'package:chat_app/screens/conversation/components/typing_indicator.dart';
import 'package:chat_app/widgets/avatar.dart';
import 'package:chat_app/widgets/avatars.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helpers/date_formats.dart';

// ignore: must_be_immutable
class ConversationList extends StatefulWidget {
  Conversation conversation;
  ConversationList({super.key, required this.conversation});
  @override
  // ignore: library_private_types_in_public_api
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  void initState() {
    super.initState();
    SocketManager().listenToEvent('typing', (data) {
      var conversationId = data['conversationId'];
      var userId = data['userId'];
      if (mounted &&
          conversationId == widget.conversation.id &&
          SharedPreferencesService.readUserData()!.id != userId) {
        Provider.of<ConversationProVider>(context, listen: false)
            .setLastMessage(
          conversationId: conversationId,
          message: Message.createRandomMessage(userId, conversationId, null,
              isTyping: true,
              createdAt: widget.conversation
                  .messages[widget.conversation.messages.length - 1].createdAt,
              updatedAt: widget.conversation
                  .messages[widget.conversation.messages.length - 1].updatedAt),
        );
        Provider.of<MessageProvider>(context, listen: false)
            .updateDataFromSocket();
      }
    });

    SocketManager().listenToEvent('cancel_typing', (data) {
      var conversationId = data['conversationId'];
      if (mounted && conversationId == widget.conversation.id) {
        final conversationId = data['conversationId'];
        final userId = data['userId'];
        if (mounted) {
          Provider.of<ConversationProVider>(context, listen: false)
              .deleteMessageTyping(conversationId, userId);
          Provider.of<MessageProvider>(context, listen: false)
              .updateDataFromSocket();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Message> messages = widget.conversation.messages;
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                widget.conversation.isGroup()
                    ? Avatars(users: widget.conversation.users, radius: 30)
                    : Avatar(user: widget.conversation.users[0], radius: 30),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.conversation.isGroup()
                              ? showNameGroup()
                              : widget.conversation.name ??
                                  widget.conversation.users[0].username,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        checkTyping(widget.conversation.messages),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          messages.isEmpty
              ? Container()
              : Text(
                  DateFormats.formatTime(
                      messages[messages.length - 1].createdAt),
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.normal),
                ),
        ],
      ),
    );
  }

  Widget checkTyping(List<Message> messages) {
    if (messages.isEmpty) return Container();
    if (messages[messages.length - 1].isTyping != null &&
        messages[messages.length - 1].isTyping!) {
      return const TypingIndicator();
    } else {
      return Text(
        widget.conversation.isGroup()
            ? showLastMessageGroup(messages)
            : showLastMessage(messages),
        style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.normal),
      );
    }
  }

  String showLastMessageGroup(List<Message> messages) {
    if (messages.isEmpty) return '';
    return SharedPreferencesService.readUserData()?.id ==
            messages[messages.length - 1].userId
        ? "Bạn: ${messages[messages.length - 1].text ?? ''}"
        : "${widget.conversation.users.firstWhere((element) => element.id == messages[messages.length - 1].userId).username}: ${messages[messages.length - 1].text ?? ''}";
  }

  String showLastMessage(List<Message> messages) {
    if (SharedPreferencesService.readUserData()?.id ==
        messages[messages.length - 1].userId) {
      if (messages[messages.length - 1].mediaUrl != null ||
          messages[messages.length - 1].asset != null) {
        return 'Bạn đã gửi 1 ảnh';
      }
      return "Bạn: ${messages[messages.length - 1].text ?? ''}";
    } else {
      String username = widget.conversation.users
          .firstWhere(
              (element) => element.id == messages[messages.length - 1].userId)
          .username;
      if (messages[messages.length - 1].mediaUrl != null ||
          messages[messages.length - 1].asset != null) {
        return "$username đã gửi 1 ảnh";
      }
      return messages[messages.length - 1].text ?? '';
    }
  }

  String showNameGroup() {
    if (widget.conversation.name != null) return widget.conversation.name!;
    return widget.conversation.users
        .map((e) => e.username)
        .reduce((value, element) {
      return "${value.split(" ").last}, ${element.split(" ").last}";
    });
  }
}
