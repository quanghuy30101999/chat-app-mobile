import 'package:chat_app/models/conversation.dart';
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
    _logic.initSocketListeners();
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
        _logic.handleGestureTap(context);
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
