import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/provider/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatMessageInput extends StatefulWidget {
  Conversation conversation;
  ChatMessageInput({
    super.key,
    required this.conversation,
  });

  @override
  State<ChatMessageInput> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends State<ChatMessageInput> {
  bool isButtonEnabled = false;
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _toggleButtonState(String text) {
    setState(() {
      isButtonEnabled = text.trim().isNotEmpty;
    });
  }

  void sendMessage() async {
    String messageText = _textEditingController.text.trim();
    if (messageText.isNotEmpty) {
      try {
        await sendMessageToProvider(messageText);
        clearTextFieldAndDisableButton();
      } catch (e) {
        // Xử lý lỗi khi gửi tin nhắn
      }
    }
  }

  Future<void> sendMessageToProvider(String messageText) async {
    await context.read<MessageProvider>().postMessage(
        conversationId: widget.conversation.id,
        text: messageText,
        onSuccess: () {
          clearTextFieldAndDisableButton();
        });
  }

  void clearTextFieldAndDisableButton() {
    _textEditingController.clear();
    setState(() {
      isButtonEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 30, right: 10),
      child: Container(
        padding: const EdgeInsets.only(left: 10, bottom: 0, top: 0),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: [
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: TextField(
                onChanged: _toggleButtonState,
                focusNode: _focusNode,
                controller: _textEditingController,
                decoration: const InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            FloatingActionButton(
              onPressed: isButtonEnabled ? sendMessage : null,
              backgroundColor: isButtonEnabled ? Colors.blue : Colors.grey,
              elevation: 0,
              child: const Icon(
                Icons.send,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
