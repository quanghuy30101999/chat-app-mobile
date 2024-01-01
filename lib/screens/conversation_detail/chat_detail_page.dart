import 'package:chat_app/helpers/socket_manager.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/provider/loading_provider.dart';
import 'package:chat_app/provider/message_provider.dart';
import 'package:chat_app/screens/conversation_detail/app_bar/conversation_app_bar.dart';
import 'package:chat_app/screens/conversation_detail/components/chat_message_input.dart';
import 'package:chat_app/screens/conversation_detail/components/chat_messages_list_view_builder.dart';
import 'package:chat_app/screens/conversation_detail/components/image_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatDetailPage extends StatefulWidget {
  Conversation conversation;
  ChatDetailPage({super.key, required this.conversation});

  @override
  ChatDetailPageState createState() => ChatDetailPageState();
}

class ChatDetailPageState extends State<ChatDetailPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ChatMessageInputState> key =
      GlobalKey<ChatMessageInputState>();
  bool _isPageOpened = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _isPageOpened = true;
    SocketManager().listenToEvent('receive_message_user', (_) {
      if (_isPageOpened) {
        Provider.of<MessageProvider>(context, listen: false)
            .updateDataFromSocket();
      }
    });
  }

  @override
  void dispose() {
    _isPageOpened = false;
    super.dispose();
  }

  void onTapOutSide() {
    Provider.of<LoadingProvider>(context, listen: false)
        .setOpenListImage(false);
  }

  void onTap() {
    key.currentState?.unfocusTextField();
    if (mounted) {
      Provider.of<LoadingProvider>(context, listen: false)
          .setOpenListImage(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: ConversationAppBar(
        conversation: widget.conversation,
        isPageOpened: _isPageOpened,
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Consumer<MessageProvider>(
                  builder: (context, myProvider, child) {
                if (_isPageOpened) {
                  return ChatMessagesListViewBuilder(
                      messages: widget.conversation.messages);
                }
                return Container();
              }),
            ),
          ),
          ChatMessageInput(
            key: key,
            conversation: widget.conversation,
            onTapOutSide: onTapOutSide,
          ),
          Selector<LoadingProvider, bool>(
            selector: (_, myModel) => myModel.isOpenListImage,
            builder: (context, value, child) {
              return value
                  ? Expanded(
                      child: ImageListScreen(
                        conversation: widget.conversation,
                      ),
                    )
                  : Container();
            },
          ),
        ],
      ),
    );
  }
}
