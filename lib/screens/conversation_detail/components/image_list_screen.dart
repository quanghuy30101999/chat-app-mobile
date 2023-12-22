import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/provider/message_provider.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';
import 'package:provider/provider.dart';

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

  void _onImageSelected(AssetEntity image) async {
    Provider.of<ConversationProVider>(context, listen: false).setLastMessage(
        conversationId: widget.conversation.id,
        message: Message(
            id: "id",
            userId: SharedPreferencesService.readUserData()!.id,
            conversationId: widget.conversation.id,
            asset: image,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()));
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    Provider.of<MessageProvider>(context, listen: false).notifyListeners();
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
