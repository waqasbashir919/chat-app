import 'package:chat_me/screens/chat_details.dart';
import 'package:chat_me/screens/login_page.dart';
import 'package:chat_me/screens/widgets/chat_body.dart';
import 'package:chat_me/screens/widgets/chat_header.dart';
import 'package:chat_me/services/auth.dart';
import 'package:flutter/material.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({Key? key, this.isPeople}) : super(key: key);
  final bool? isPeople;
  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pinkAccent,
      appBar: AppBar(
        title: Text('Peoples'),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 10),
        //     child: GestureDetector(
        //         onTap: () async {
        //           await auth.signOut();
        //           Navigator.of(context).pushReplacement(
        //             MaterialPageRoute(builder: (context) => LoginPage()),
        //           );
        //         },
        //         child: Icon(Icons.logout)),
        //   )
        // ],
      ),
      body: SafeArea(
        child: Container(
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(30),
          //       topRight: Radius.circular(30),
          //     ),
          //     color: Colors.white),
          height: MediaQuery.of(context).size.height,
          child: chatBody(isChat: false, isPeople: widget.isPeople),
        ),
      ),
    );
  }
}
