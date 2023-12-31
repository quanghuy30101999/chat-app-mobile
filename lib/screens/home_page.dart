import 'package:chat_app/helpers/shared_preferences.dart';
import 'package:chat_app/helpers/socket_manager.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/provider/conversation_provider.dart';
import 'package:chat_app/provider/loading_provider.dart';
import 'package:chat_app/screens/channels/channels_page.dart';
import 'package:chat_app/screens/conversation/conversation_page.dart';
import 'package:chat_app/screens/login/login_page.dart';
import 'package:chat_app/screens/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int navIndex = 0;
  late List<Widget> selectedPage;

  @override
  void initState() {
    selectedPage = [
      ConversationPage(
        onSuccess: createRoom,
      ),
      const ChannelsPage(),
      ProfilePage()
    ];
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    connect();
    SocketManager().listenToEvent('error', (error) {
      SharedPreferencesService.clearUserData();
      if (mounted) {
        Provider.of<ConversationProVider>(context, listen: false).clearData();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      connect();
      bool isInCameraMode =
          Provider.of<LoadingProvider>(context, listen: false).isInCameraMode;
      if (!isInCameraMode) {
        await Provider.of<ConversationProVider>(context, listen: false)
            .getConversations(onSuccess: (conversations) {
          if (conversations.isNotEmpty) {
            String? fcmToken = SharedPreferencesService.getFcmToken();
            List<String> convesationIds =
                conversations.map((e) => e.id).toList();
            Map<String, dynamic> data = {
              'fcmToken': fcmToken,
              'conversationIds': convesationIds,
              'userId': SharedPreferencesService.readUserData()?.id
            };
            SocketManager().emitEvent('join_room', data);
          }
        });
      }
      // ignore: use_build_context_synchronously
      Provider.of<LoadingProvider>(context, listen: false)
          .setInCameraMode(false);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SocketManager().closeConnection();
    super.dispose();
  }

  void connect() {
    SocketManager().connectToServer();
  }

  void createRoom(List<Conversation> conversations) async {
    if (conversations.isNotEmpty) {
      String? fcmToken = SharedPreferencesService.getFcmToken();
      List<String> convesationIds = conversations.map((e) => e.id).toList();
      Map<String, dynamic> data = {
        'fcmToken': fcmToken,
        'conversationIds': convesationIds,
        'userId': SharedPreferencesService.readUserData()?.id
      };
      SocketManager().emitEvent('join_room', data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: navIndex,
        children: selectedPage,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            navIndex = index;
          });
        },
        currentIndex: navIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Tin nhắn",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            label: "Nhóm",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: "Trang cá nhân",
          ),
        ],
      ),
    );
  }
}
