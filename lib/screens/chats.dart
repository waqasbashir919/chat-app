import 'package:chat_me/screens/chat_details.dart';
import 'package:chat_me/screens/login_page.dart';
import 'package:chat_me/screens/widgets/chat_body.dart';
import 'package:chat_me/screens/widgets/chat_header.dart';
import 'package:chat_me/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, this.isChat}) : super(key: key);
  final bool? isChat;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              chatHeader(),
              chatBody(
                isChat: widget.isChat,
                isPeople: false,
              )
            ],
          ),
        ),
      ),
    );
  }
}
