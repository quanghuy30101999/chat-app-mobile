import 'package:chat_app/screens/channels/channels_widgets.dart';
import 'package:flutter/material.dart';

class ChannelsPage extends StatefulWidget {
  const ChannelsPage({super.key});

  @override
  State<ChannelsPage> createState() => _ChannelsPageState();
}

class _ChannelsPageState extends State<ChannelsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ChannelsWidgets.buildSafeArea(context),
            ChannelsWidgets.buildConversationListView(),
          ],
        ),
      ),
    );
  }
}
