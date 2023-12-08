import 'package:chat_app/helpers/date_formats.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/screens/conversation/components/conversation_list.dart';
import 'package:chat_app/screens/conversation/components/search.dart';
import 'package:chat_app/screens/conversation/components/user_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  List<User> users = [
    User(
        id: 'id',
        username: 'Trần Quang Huy',
        isOnline: false,
        isAdmin: false,
        avatarUrl:
            "https://i.pinimg.com/736x/40/0e/b8/400eb8a3081a741b593f12591ac40036.jpg",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    User(
        id: 'id',
        username: 'Trần Thị Phương Vy',
        isOnline: false,
        isAdmin: false,
        avatarUrl:
            "https://i.pinimg.com/736x/40/0e/b8/400eb8a3081a741b593f12591ac40036.jpg",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    User(
        id: 'id',
        username: 'Huỳnh Văn Tú',
        isOnline: false,
        isAdmin: false,
        avatarUrl:
            "https://i.pinimg.com/736x/40/0e/b8/400eb8a3081a741b593f12591ac40036.jpg",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now()),
    User(
        id: 'id',
        username: 'Trần Phương Nhi',
        isOnline: false,
        isAdmin: false,
        avatarUrl:
            "https://i.pinimg.com/736x/40/0e/b8/400eb8a3081a741b593f12591ac40036.jpg",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now())
  ];
  bool isFocus = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      await Provider.of<ConversationProVider>(context, listen: false)
          .getConversations();
      // ignore: empty_catches
    } catch (error) {}
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
                focus: (value) {
                  if (!value) FocusScope.of(context).unfocus();
                  setState(() {
                    isFocus = value;
                  });
                },
              ),
              isFocus
                  ? ListView.builder(
                      itemCount: users.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 16),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return UserList(
                          user: users[index],
                        );
                      },
                    )
                  : Selector<ConversationProVider, List<Conversation>>(
                      selector: (context, provider) => provider.conversations,
                      builder: (context, conversations, child) {
                        return ListView.builder(
                          itemCount: conversations.length,
                          shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 16),
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ConversationList(
                              name: conversations[index].name ??
                                  conversations[index].users[0].username,
                              messageText:
                                  conversations[index].lastMessage?.text ?? '',
                              imageUrl:
                                  "https://i.pinimg.com/736x/40/0e/b8/400eb8a3081a741b593f12591ac40036.jpg",
                              time: DateFormats.formatTime(
                                  conversations[index].createdAt),
                              isMessageRead:
                                  (index == 0 || index == 3) ? true : false,
                            );
                          },
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
