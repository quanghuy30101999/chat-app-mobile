import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/screens/conversation_detail/app_bar/components/avatar.dart';
import 'package:chat_app/screens/conversation_detail/app_bar/components/user_info_display.dart';
import 'package:chat_app/widgets/icon_arrow_back.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ConversationAppBar extends StatefulWidget implements PreferredSizeWidget {
  ConversationAppBar({super.key, required this.conversation});
  Conversation conversation;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<ConversationAppBar> createState() => _ConversationAppBarState();
}

class _ConversationAppBarState extends State<ConversationAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              const IconArrowBack(),
              const SizedBox(
                width: 2,
              ),
              Avatar(avatarUrl: widget.conversation.users[0].avatarUrl),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                  child: UserInfoDisplay(
                user: widget.conversation.users[0],
              )),
              const Icon(
                Icons.settings,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
