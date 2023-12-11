import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/provider/message_provider.dart';
import 'package:chat_app/screens/conversation_detail/app_bar/conversation_app_bar.dart';
import 'package:chat_app/screens/conversation_detail/components/chat_message_input.dart';
import 'package:chat_app/screens/conversation_detail/components/chat_messages_list_view_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatDetailPage extends StatefulWidget {
  Conversation conversation;
  ChatDetailPage({super.key, required this.conversation});

  @override
  // ignore: library_private_types_in_public_api
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  @override
  void initState() {
    super.initState();
    loadMessages();
  }

  Future<void> loadMessages() async {
    try {
      await Provider.of<MessageProvider>(context, listen: false)
          .getMessage(conversationId: widget.conversation.id);
      // ignore: empty_catches
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: ConversationAppBar(
          conversation: widget.conversation,
        ),
        body: Column(
          children: [
            const Expanded(child: ChatMessagesListViewBuilder()),
            ChatMessageInput(conversation: widget.conversation)
          ],
        ),
      ),
    );
  }
}
