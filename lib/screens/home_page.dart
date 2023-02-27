import 'package:chat_me/screens/chat_details.dart';
import 'package:chat_me/screens/chats.dart';
import 'package:chat_me/screens/peoples.dart';
import 'package:chat_me/screens/settings.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  bool isChat = true;
  bool isPeople = false;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      ChatPage(isChat: isChat),
      PeoplePage(isPeople: isPeople),
      SettingsPage()
    ];
    return SafeArea(
        child: Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              currentIndex = index;
              if (currentIndex == 0) {
                isChat = true;
                isPeople = false;
              } else if (currentIndex == 1) {
                isPeople = true;
                isChat = false;
              }
            });
          },
          currentIndex: currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chats',
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                label: 'People',
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
                backgroundColor: Colors.black),
          ]),
    ));
  }
}
