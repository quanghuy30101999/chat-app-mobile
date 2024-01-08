import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewGroup extends StatefulWidget {
  const NewGroup({super.key});

  @override
  State<NewGroup> createState() => _NewGroupState();
}

class _NewGroupState extends State<NewGroup> {
  late List<bool> isSelectedList;
  List<Conversation> isSelected = [];
  bool _initialized = false;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _nameGroupEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ConversationProVider>(context, listen: false).allUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      var users =
          Provider.of<ConversationProVider>(context, listen: false).users;
      isSelectedList = List.filled(users.length, false);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Consumer<ConversationProVider>(
      builder: (context, myModel, child) {
        return SizedBox(
          width: media.width,
          height: media.height * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: <Widget>[
                buildHeader(),
                TextField(
                  controller: _nameGroupEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Tên nhóm (không bắt buộc)',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                    border: InputBorder.none,
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                  cursorHeight: 15,
                ),
                buildSearchField(),
                buildSelectedAvatars(myModel),
                buildListView(myModel),
              ],
            ),
          ),
        );
      },
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
        const Text(
          'Nhóm mới',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          onTap: _onCreate,
          child: Text(
            'Tạo',
            style: TextStyle(
                color: isSelected.length >= 2
                    ? Colors.blue[500]
                    : Colors.grey[700],
                fontSize: 15),
          ),
        ),
      ],
    );
  }

  void _onCreate() async {
    if (isSelected.length >= 2) {
      var userIds = isSelected.map((e) => e.users[0].id).toList();
      var loginUser = SharedPreferencesService.readUserData();
      if (loginUser != null) userIds.add(loginUser.id);
      await Provider.of<ConversationProVider>(context, listen: false)
          .createGroup(
              name: _nameGroupEditingController.text, userIds: userIds);
      _onClose();
    }
  }

  Widget buildSearchField() {
    return SizedBox(
      height: 40,
      child: TextField(
        controller: _textEditingController,
        onChanged: (text) {},
        cursorHeight: 20,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[200],
          hintText: 'Tìm kiếm',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildSelectedAvatars(ConversationProVider myModel) {
    return isSelected.isNotEmpty
        ? SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: isSelected.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      buildAvatarWithCloseButton(myModel, myModel.users[index]),
                );
              },
            ),
          )
        : Container();
  }

  Widget buildAvatarWithCloseButton(
      ConversationProVider myModel, Conversation user) {
    return Stack(
      children: [
        const CircleAvatar(
          backgroundImage: AssetImage('assets/images/avatar.png'),
          // NetworkImage(
          //     'https://i.pinimg.com/736x/40/0e/b8/400eb8a3081a741b593f12591ac40036.jpg'),
          radius: 25,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isSelectedList[myModel.users.indexOf(user)] = false;
                isSelected.remove(user);
              });
            },
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildListView(ConversationProVider myModel) {
    return Expanded(
      child: ListView.builder(
        itemCount: myModel.users.length,
        itemBuilder: (BuildContext context, int index) {
          return buildUserRow(myModel, myModel.users[index], index);
        },
      ),
    );
  }

  Widget buildUserRow(
      ConversationProVider myModel, Conversation user, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelectedList[index]) {
            isSelected.remove(user);
          } else {
            isSelected.add(user);
          }
          isSelectedList[index] = !isSelectedList[index];
        });
      },
      child: Padding(
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
                      user.users[0].username,
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
            buildCheckIcon(index),
          ],
        ),
      ),
    );
  }

  Widget buildCheckIcon(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelectedList[index] ? Colors.blue : Colors.grey,
              width: 2,
            ),
            color: isSelectedList[index] ? Colors.blue : Colors.transparent,
          ),
          child: isSelectedList[index]
              ? const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                )
              : null,
        ),
      ],
    );
  }
}
