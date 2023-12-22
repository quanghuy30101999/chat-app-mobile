import 'package:chat_app/helpers/socket_manager.dart';
import 'package:chat_app/models/conversation.dart';
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
  // ignore: library_private_types_in_public_api
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  bool _isPageOpened = false;
  bool _isOpenListImage = false;

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   // FocusScope.of(context).unfocus();
      //   if (_isOpenListImage) {
      //     // setState(() {
      //     //   _isOpenListImage = false;
      //     // });
      //   }
      // },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: ConversationAppBar(
          conversation: widget.conversation,
          isPageOpened: _isPageOpened,
        ),
        body: Column(
          children: [
            Consumer<MessageProvider>(builder: (context, myProvider, child) {
              if (_isPageOpened) {
                return Expanded(
                    child: ChatMessagesListViewBuilder(
                        messages: widget.conversation.messages));
              }
              return Container();
            }),
            ChatMessageInput(
              conversation: widget.conversation,
              openListImage: _openImages,
            ),
            if (_isOpenListImage)
              Expanded(
                child: ImageListScreen(
                  conversation: widget.conversation,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _openImages() {
    setState(() {
      _isOpenListImage = true;
    });
  }
}
