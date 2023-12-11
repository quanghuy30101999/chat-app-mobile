import 'package:chat_app/models/message.dart';
import 'package:chat_app/provider/message_provider.dart';
import 'package:chat_app/screens/conversation_detail/components/message_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatMessagesListViewBuilder extends StatefulWidget {
  const ChatMessagesListViewBuilder({super.key});

  @override
  State<ChatMessagesListViewBuilder> createState() =>
      _ChatMessagesListViewBuilderState();
}

class _ChatMessagesListViewBuilderState
    extends State<ChatMessagesListViewBuilder> {
  final ScrollController _scrollController = ScrollController();
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
                Selector<MessageProvider, List<Message>>(
                    selector: (context, provider) => provider.messages,
                    builder: (context, messages, index) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: messages.length,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        itemBuilder: (context, index) {
                          return MessageDetail(message: messages[index]);
                        },
                      );
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
