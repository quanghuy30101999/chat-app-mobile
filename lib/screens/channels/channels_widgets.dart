// conversation_widgets.dart

import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/screens/conversation_detail/chat_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/screens/conversation/components/conversation_list.dart';

class ChannelsWidgets {
  static Widget buildSafeArea(BuildContext context) {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Nhóm",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildConversationListView() {
    return Consumer<ConversationProVider>(
      builder: (context, myModel, child) {
        return ListView.builder(
          itemCount: myModel.groups.length,
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 16),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Future.delayed(const Duration(milliseconds: 150), () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatDetailPage(conversation: myModel.groups[index]);
                  }));
                });
              },
              child: ConversationList(
                conversation: myModel.groups[index],
              ),
            );
          },
        );
      },
    );
  }
}
