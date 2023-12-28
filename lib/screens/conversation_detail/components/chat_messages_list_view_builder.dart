import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/helpers/socket_manager.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/provider/message_provider.dart';
import 'package:chat_app/screens/conversation_detail/components/message_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    // SocketManager().listenToEvent('typing', (data) {
    //   final conversationId = data['conversationId'];
    //   final userId = data['userId'];
    //   if (mounted && SharedPreferencesService.readUserData()!.id != userId) {
    //     Provider.of<ConversationProVider>(context, listen: false)
    //         .setLastMessage(
    //       conversationId: conversationId,
    //       message: Message.createRandomMessage(userId, conversationId, null,
    //           isTyping: true),
    //     );
    //     Provider.of<MessageProvider>(context, listen: false)
    //         .updateDataFromSocket();
    //   }
    // });

    // SocketManager().listenToEvent('cancel_typing', (data) {
    //   final conversationId = data['conversationId'];
    //   final userId = data['userId'];
    //   if (mounted && SharedPreferencesService.readUserData()!.id != userId) {
    //     Provider.of<ConversationProVider>(context, listen: false)
    //         .deleteMessageTyping(conversationId, userId);
    //     Provider.of<MessageProvider>(context, listen: false)
    //         .updateDataFromSocket();
    //   }
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
    // SocketManager().emitEvent(
    //     'cancel_typing', {'conversationId': widget.messages[0].conversationId});
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
