import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/conversation_detail/components/message_detail.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ChatMessagesListViewBuilder extends StatefulWidget {
  List<Message> messages;
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

  // void _scroll({double position = 0.0}) {
  //   _scrollController.animateTo(
  //       _scrollController.position.minScrollExtent + position,
  //       duration: const Duration(microseconds: 300),
  //       curve: Curves.bounceInOut);
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        SizedBox(
          height: media.height * 0.75,
          child: SingleChildScrollView(
            reverse: true,
            controller: _scrollController,
            physics: const ScrollPhysics(),
            child: Column(
              children: [
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.messages.length,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  itemBuilder: (context, index) {
                    return MessageDetail(message: widget.messages[index]);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
