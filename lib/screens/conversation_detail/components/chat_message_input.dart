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
  bool _isFocused = false;
  double radius = 20;

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
      child: SizedBox(
        width: double.infinity,
        child: Row(
          children: [
            _buildActionIcon(Icons.add),
            const SizedBox(width: 15),
            if (!_isFocused) ...[
              _buildActionIcon(Icons.camera_alt),
              const SizedBox(width: 15),
              _buildActionIcon(Icons.image),
              const SizedBox(width: 15),
            ],
            Expanded(
              child: IntrinsicHeight(
                child: Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      _isFocused = hasFocus;
                    });
                  },
                  child: TextField(
                    maxLines: _isFocused ? null : 1,
                    onChanged: _toggleButtonState,
                    focusNode: _focusNode,
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(top: 10, left: 20, right: 20),
                      filled: true,
                      fillColor: Colors.grey[300],
                      hintText: "Aa",
                      hintStyle: const TextStyle(color: Colors.black54),
                      focusColor: Colors.grey,
                      focusedBorder: _buildInputBorder(),
                      border: _buildInputBorder(),
                      enabledBorder: _buildInputBorder(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
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

  Widget _buildActionIcon(IconData icon) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  OutlineInputBorder _buildInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: const BorderSide(color: Colors.transparent),
    );
  }
}
