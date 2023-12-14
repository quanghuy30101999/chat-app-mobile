import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/avatar.dart';
import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    List<Message> messages = widget.conversation.messages;
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Avatar(user: widget.conversation.users[0], radius: 30),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.conversation.name ??
                              widget.conversation.users[0].username,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          SharedPreferencesService.readUserData()?.id ==
                                  messages[messages.length - 1].userId
                              ? "Bạn: ${messages[messages.length - 1].text ?? ''}"
                              : messages[messages.length - 1].text ?? '',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight:
                                  // widget.isMessageRead
                                  // ? FontWeight.bold
                                  // :
                                  FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            DateFormats.formatTime(messages[messages.length - 1].createdAt),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }
}
