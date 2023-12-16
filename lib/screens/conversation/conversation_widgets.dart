// conversation_widgets.dart

import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/screens/conversation/components/new_group.dart';
import 'package:chat_app/screens/conversation_detail/chat_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/screens/conversation/components/search.dart';
import 'package:chat_app/screens/conversation/components/conversation_list.dart';
import 'package:chat_app/screens/conversation/components/user_list.dart';

class ConversationWidgets {
  static Widget buildSafeArea(BuildContext context) {
    // Build SafeArea widget
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              "Cuộc trò chuyện",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return _buildBottomSheetContent(
                        context); // Hiển thị bottom sheet khi nhấn nút
                  },
                );
              },
              child: const Icon(Icons.group),
            )
          ],
        ),
      ),
    );
  }

  static _buildBottomSheetContent(BuildContext context) {
    return const NewGroup();
  }

  static Widget buildSearch({
    required Function(String?) onChange,
    required Function(bool) onFocus,
  }) {
    // Build Search widget
    return Search(
      onChangeText: onChange,
      focus: onFocus,
    );
  }

  static Widget buildUserListView() {
    return Selector<ConversationProVider, List<Conversation>>(
        selector: (context, provider) => provider.users,
        builder: (context, conversations, child) {
          return ListView.builder(
            itemCount: conversations.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ChatDetailPage(conversation: conversations[index]);
                    }));
                  });
                },
                child: UserList(
                  users: conversations[index].users,
                ),
              );
            },
          );
        });
  }

  static Widget buildConversationListView() {
    // Build ConversationListView widget
    return Consumer<ConversationProVider>(
      builder: (context, myModel, child) {
        return ListView.builder(
          itemCount: myModel.conversations.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 16),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Future.delayed(const Duration(milliseconds: 150), () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatDetailPage(
                        conversation: myModel.conversations[index]);
                  }));
                });
              },
              child: ConversationList(
                conversation: myModel.conversations[index],
              ),
            );
          },
        );
      },
    );
  }
}
