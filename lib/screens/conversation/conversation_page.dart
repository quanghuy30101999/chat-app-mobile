import 'dart:async';
import 'package:chat_app/helpers/socket_manager.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/screens/conversation_detail/chat_detail_page.dart';
import 'package:chat_app/screens/conversation/components/conversation_list.dart';
import 'package:chat_app/screens/conversation/components/search.dart';
import 'package:chat_app/screens/conversation/components/user_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

// ignore: must_be_immutable
class ConversationPage extends StatefulWidget {
  Function onSuccess;
  ConversationPage({super.key, required this.onSuccess});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  bool isFocus = false;
  @override
  void initState() {
    super.initState();
    loadData();
    SocketManager().listenToEvent('receive_message', (data) {
      Message message = Message.fromJson(data);
      Provider.of<ConversationProVider>(context, listen: false).setLastMessage(
          conversationId: message.conversationId, message: message);
    });

    SocketManager().listenToEvent('update_online_status', (data) {
      Provider.of<ConversationProVider>(context, listen: false)
          .updateStatusOnline(
              conversationIds: data['conversationIds'].cast<String>(),
              userId: data['userId']);
    });

    SocketManager().listenToEvent('user_disconnect', (data) {
      Provider.of<ConversationProVider>(context, listen: false)
          .updateUserOffline(
              data['conversationId'], User.fromJson(data['user']));
    });
  }

  Future<void> loadData() async {
    try {
      await Provider.of<ConversationProVider>(context, listen: false)
          .getConversations(onSuccess: (conversations) {
        widget.onSuccess.call();
      });
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
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        "Conversations",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.pink[50],
                        ),
                        child: const Row(
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.pink,
                              size: 20,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Add New",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Search(
                onChangeText: (text) {
                  if (text != null) {
                    Provider.of<ConversationProVider>(context, listen: false)
                        .getUsers(text: text);
                  }
                },
                focus: (value) {
                  if (!value) FocusScope.of(context).unfocus();
                  setState(() {
                    isFocus = value;
                  });
                },
              ),
              isFocus
                  ? Selector<ConversationProVider, List<Conversation>>(
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
                                Future.delayed(
                                    const Duration(milliseconds: 200), () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ChatDetailPage(
                                        conversation: conversations[index]);
                                  }));
                                });
                              },
                              child: UserList(
                                user: conversations[index].users[0],
                              ),
                            );
                          },
                        );
                      })
                  : Consumer<ConversationProVider>(
                      builder: (context, myModel, child) {
                        return ListView.builder(
                          itemCount: myModel.conversations.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Future.delayed(
                                    const Duration(milliseconds: 200), () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ChatDetailPage(
                                        conversation:
                                            myModel.conversations[index]);
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
                    )
            ],
          ),
        ),
      ),
    );
  }
}
