import 'package:chat_app/helpers/socket_manager.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/screens/conversation/conversation_logic.dart';
import 'package:chat_app/screens/conversation/conversation_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ConversationPage extends StatefulWidget {
  Function(List<Conversation>) onSuccess;
  ConversationPage({super.key, required this.onSuccess});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> with RouteAware {
  late bool isFocus;
  late ConversationLogic _logic;
  @override
  void initState() {
    super.initState();
    loadData();
    isFocus = false;
    _logic = ConversationLogic(context: context);
    initSocketListeners();
  }

  void initSocketListeners() {
    SocketManager().listenToEvent('receive_message', (data) {
      if (mounted) {
        Message message = Message.fromJson(data);
        try {
          Provider.of<ConversationProVider>(context, listen: false)
              .setLastMessage(
            conversationId: message.conversationId,
            message: message,
          );
        } catch (e) {
          print(e);
        }
      }
    });

    SocketManager().listenToEvent('update_online_status', (data) {
      if (mounted) {
        Provider.of<ConversationProVider>(context, listen: false)
            .updateStatusOnline(
                conversationIds: data['conversationIds'].cast<String>(),
                userId: data['userId']);
      }
    });

    SocketManager().listenToEvent('user_disconnect', (data) {
      if (mounted) {
        print('user_disconnect');
        Provider.of<ConversationProVider>(context, listen: false)
            .updateUserOffline(
                data['conversationId'], User.fromJson(data['user']));
      }
    });

    SocketManager().listenToEvent('delete_group', (conversationId) {
      if (mounted) {
        print('delete group');
        context
            .read<ConversationProVider>()
            .deleteFromSocket(conversationId: conversationId);
        SocketManager().emitEvent('leaveRoom', conversationId);
      }
    });

    SocketManager().listenToEvent('new_group', (conversation) {
      if (mounted) {
        var newConversation = Conversation.fromJson(conversation);
        context.read<ConversationProVider>().addGroup(newConversation);
        SocketManager().emitEvent('join_group', newConversation.id);
      }
    });
  }

  Future<void> loadData() async {
    try {
      if (Provider.of<ConversationProVider>(context, listen: false)
          .conversations
          .isEmpty) {
        await Provider.of<ConversationProVider>(context, listen: false)
            .getConversations(onSuccess: (conversations) {
          widget.onSuccess.call(conversations);
        });
      }
      // ignore: empty_catches
    } catch (error) {}
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _logic.handleGestureTap();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ConversationWidgets.buildSafeArea(context),
              ConversationWidgets.buildSearch(
                  onChange: _logic.onChange, onFocus: onFocus),
              isFocus
                  ? ConversationWidgets.buildUserListView()
                  : ConversationWidgets.buildConversationListView(),
            ],
          ),
        ),
      ),
    );
  }

  void onFocus(bool value) {
    if (!value) FocusScope.of(context).unfocus();
    setState(() {
      isFocus = value;
    });
  }
}
