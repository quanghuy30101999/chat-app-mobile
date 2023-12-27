import 'dart:io';

import 'package:chat_app/helpers/event_bus.dart';
import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/provider/loading_provider.dart';
import 'package:chat_app/provider/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatMessageInput extends StatefulWidget {
  Conversation conversation;
  Function onTapOutSide;
  ChatMessageInput(
      {super.key, required this.conversation, required this.onTapOutSide});

  @override
  State<ChatMessageInput> createState() => ChatMessageInputState();
}

class ChatMessageInputState extends State<ChatMessageInput> {
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

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  void unfocusTextField() {
    _focusNode.unfocus();
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
        onSuccess: (_) {
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
            _buildActionIcon(Icons.add, 'add'),
            const SizedBox(width: 15),
            if (!_isFocused) ...[
              _buildActionIcon(Icons.camera_alt, 'camera_alt'),
              const SizedBox(width: 15),
              _buildActionIcon(Icons.image, 'image'),
              const SizedBox(width: 15),
            ],
            Expanded(
              child: IntrinsicHeight(
                child: Focus(
                  onFocusChange: (hasFocus) {
                    if (hasFocus) widget.onTapOutSide.call();
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
              onPressed: isButtonEnabled ? sendMessage : () {},
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

  Future<void> openCamera() async {
    Provider.of<LoadingProvider>(context, listen: false).setInCameraMode(true);
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      String imagePath = pickedFile.path;
      print('Image from gallery: $imagePath');
      await saveImageToGallery(pickedFile);
    }
  }

  Future<void> getAssetEntityFromImagePath(String imagePath) async {
    List<AssetPathEntity> albums =
        await PhotoManager.getAssetPathList(onlyAll: true);
    AssetPathEntity cameraRollAlbum = albums.firstWhere((album) => album.isAll);

    List<AssetEntity> images =
        await cameraRollAlbum.getAssetListRange(start: 0, end: 1);

    if (images.isNotEmpty) {
      AssetEntity firstImage = images.first;
      await _onImageSelected(firstImage);
    } else {
      print('No images found in the album');
    }
  }

  Message createMessage(AssetEntity image) {
    Message randomMessage = Message.createRandomMessage(
        SharedPreferencesService.readUserData()!.id,
        widget.conversation.id,
        image);
    return randomMessage;
  }

  Future<Message> xxx(AssetEntity image) async {
    Message oldMessage = createMessage(image);
    Provider.of<ConversationProVider>(context, listen: false).setLastMessage(
        conversationId: widget.conversation.id, message: oldMessage);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    Provider.of<MessageProvider>(context, listen: false).notifyListeners();
    return oldMessage;
  }

  Future<void> _onImageSelected(AssetEntity image) async {
    Message oldMessage = await xxx(image);
    // ignore: use_build_context_synchronously
    Provider.of<MessageProvider>(context, listen: false).sendImage(
      conversationId: widget.conversation.id,
      imagePath: await image.file,
      onSuccess: (newMessage) {
        var data = {
          "conversationId": widget.conversation.id,
          "oldMessage": oldMessage
        };
        EventBus().emit('eventName', data);
      },
      onError: () {},
    );
  }

  Future<void> saveImageToGallery(XFile imageFile) async {
    final appDir = await getTemporaryDirectory();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedImagePath = '${appDir.path}/$fileName';

    final newFile = await File(imageFile.path).copy(savedImagePath);
    final result = await GallerySaver.saveImage(newFile.path);
    if (result != null && result) {
      await getAssetEntityFromImagePath(newFile.path);
    }
  }

  void onTapIcon(String type) async {
    switch (type) {
      case 'camera_alt':
        await openCamera();
        break;
      case 'image':
        _focusNode.unfocus();
        Provider.of<LoadingProvider>(context, listen: false)
            .setOpenListImage(true);
        break;
      case 'add':
        break;
      default:
    }
  }

  Widget _buildActionIcon(IconData icon, String type) {
    return GestureDetector(
      onTap: () {
        onTapIcon(type);
      },
      child: Container(
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
