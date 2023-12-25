import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/provider/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';

import '../../../helpers/event_bus.dart';

// ignore: must_be_immutable
class ImageListScreen extends StatefulWidget {
  Conversation conversation;

  ImageListScreen({super.key, required this.conversation});

  @override
  // ignore: library_private_types_in_public_api
  _ImageListScreenState createState() => _ImageListScreenState();
}

class _ImageListScreenState extends State<ImageListScreen> {
  List<AssetEntity> _images = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
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

  void _onImageSelected(AssetEntity image) async {
    Message oldMessage = await xxx(image);
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

  Future<bool> requestPermission() async {
    PermissionStatus status = await Permission.photos.request();
    return status.isGranted;
  }

  Future<void> _fetchImages() async {
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
    if (albums.isNotEmpty) {
      List<AssetEntity> allAssets =
          await albums[0].getAssetListPaged(page: 0, size: 1000);

      List<AssetEntity> images = allAssets.where((asset) {
        return asset.type == AssetType.image;
      }).toList();

      setState(() {
        _images = images;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: _images.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => _onImageSelected(_images[index]),
            child: FutureBuilder<Uint8List?>(
              future: _images[index].originBytes,
              builder:
                  (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.data != null) {
                  return Image.memory(snapshot.data!, fit: BoxFit.cover);
                } else {
                  return Container();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
