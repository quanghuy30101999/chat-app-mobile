import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/provider/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ForwardMessage extends StatefulWidget {
  Message message;
  ForwardMessage({super.key, required this.message});

  @override
  State<ForwardMessage> createState() => _ForwardMessageState();
}

class _ForwardMessageState extends State<ForwardMessage> {
  late List<bool> listButton;
  late List<Conversation> combinedList;

  @override
  void initState() {
    super.initState();
    combinedList = [];
    final groups = context.read<ConversationProVider>().groups;
    final conversations = context.read<ConversationProVider>().conversations;
    combinedList = groups + conversations;
    listButton = List.filled(combinedList.length, false);
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
      width: media.width,
      height: media.height * 0.9,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
          buildHeader(),
          buildListView(),
        ]),
      ),
    );
  }

  Widget buildListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: combinedList.length,
        itemBuilder: (BuildContext context, int index) {
          return buildUserRow(combinedList[index], index);
        },
      ),
    );
  }

  Widget buildUserRow(Conversation myModel, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 80,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'),

              // NetworkImage(
              //   'https://i.pinimg.com/736x/40/0e/b8/400eb8a3081a741b593f12591ac40036.jpg',
              // ),
              radius: 25,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                SizedBox(
                  height: 49,
                  child: Text(
                    myModel.isGroup()
                        ? showNameGroup(myModel)
                        : myModel.users[0].username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 211, 206, 206),
            onPressed: () {
              context
                  .read<MessageProvider>()
                  .forwardMessage(myModel.id, widget.message.id, onSuccess: () {
                setState(() {
                  listButton[index] = true;
                });
              });
            },
            child: Text(
              // Constants.statuses[widget.message.messageStatus]!,
              listButton[index] ? 'Đã gửi' : 'Gửi',
              style: const TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  void _onClose() {
    Navigator.pop(context);
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: _onClose,
          child: Text(
            'Huỷ',
            style: TextStyle(color: Colors.blue[500], fontSize: 15),
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              'Chuyển tiếp',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String showNameGroup(Conversation conversation) {
    if (conversation.name != null) return conversation.name!;
    return conversation.users.map((e) => e.username).reduce((value, element) {
      return "${value.split(" ").last}, ${element.split(" ").last}";
    });
  }
}
