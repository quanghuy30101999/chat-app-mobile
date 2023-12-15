import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/helpers/socket_manager.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/screens/conversation/conversation_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    connect();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      connect();

      await Provider.of<ConversationProVider>(context, listen: false)
          .getConversations(onSuccess: (conversations) {
        if (conversations.isNotEmpty) {
          List<String> convesationIds = conversations.map((e) => e.id).toList();
          Map<String, dynamic> data = {
            'conversationIds': convesationIds,
            'userId': SharedPreferencesService.readUserData()?.id
          };
          SocketManager().emitEvent('join_room', data);
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void connect() {
    SocketManager().connectToServer();
  }

  void createRoom(List<Conversation> conversations) async {
    if (conversations.isNotEmpty) {
      List<String> convesationIds = conversations.map((e) => e.id).toList();
      Map<String, dynamic> data = {
        'conversationIds': convesationIds,
        'userId': SharedPreferencesService.readUserData()?.id
      };
      SocketManager().emitEvent('join_room', data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConversationPage(
        onSuccess: createRoom,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Chats",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            label: "Channels",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
