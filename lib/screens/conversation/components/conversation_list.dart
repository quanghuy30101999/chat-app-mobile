import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
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
  late List<Message> messages;

  @override
  void initState() {
    messages = widget.conversation.messages;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(widget
                          .conversation.users[0].avatarUrl ??
                      "https://i.pinimg.com/736x/40/0e/b8/400eb8a3081a741b593f12591ac40036.jpg"),
                  maxRadius: 30,
                ),
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
