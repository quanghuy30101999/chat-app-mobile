import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/conversation_detail/components/message_detail.dart';
import 'package:flutter/material.dart';

class ChatMessagesListViewBuilder extends StatefulWidget {
  final List<Message> messages;

  ChatMessagesListViewBuilder({super.key, required this.messages});

  @override
  State<ChatMessagesListViewBuilder> createState() =>
      _ChatMessagesListViewBuilderState();
}

class _ChatMessagesListViewBuilderState
    extends State<ChatMessagesListViewBuilder> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      reverse: true,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: widget.messages.length,
        itemBuilder: (context, index) {
          return MessageDetail(message: widget.messages[index]);
        },
      ),
    );
  }
}
