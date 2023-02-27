import 'package:chat_me/model/user.dart';
import 'package:chat_me/screens/chat_details.dart';
import 'package:chat_me/services/database.dart';
import 'package:chat_me/services/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class chatBody extends StatefulWidget {
  const chatBody({
    Key? key,
    this.isChat,
    this.isPeople,
  }) : super(key: key);
  final bool? isChat, isPeople;

  @override
  State<chatBody> createState() => _chatBodyState();
}

class _chatBodyState extends State<chatBody> {
  DatabaseMethods databaseMethods = DatabaseMethods();
  TextEditingController searchChat = TextEditingController();
  String searchText = '';
  var data;
  var currentUser;
  var username;
  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade200,
            ),
            child: TextField(
              controller: searchChat,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                prefixIcon: GestureDetector(
                    onTap: () {
                      // databaseMethods
                      //     .getUserByUsername(searchChat.text)
                      //     .then((val) {
                      //   setState(() {
                      //     querySnapshot = val;
                      //   });
                      // });

                      setState(() {
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    child: Icon(Icons.search)),
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        searchChat.text = '';
                        searchText = '';
                      });
                    },
                    child: searchChat.text.isNotEmpty
                        ? Icon(Icons.clear)
                        : SizedBox()),
                hintText: 'Search Contact',
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseApi().fetchUserfromFirebase(),
                    builder: (context, snapshot) {
                      return (snapshot.connectionState ==
                              ConnectionState.waiting)
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: ((context, index) {
                                data = snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                                if (currentUser.email ==
                                    snapshot.data!.docs[index]['email']) {
                                  username =
                                      snapshot.data!.docs[index]['username'];
                                }

                                if (searchText.isEmpty) {
                                  if (currentUser.email != data["email"]) {
                                    return user(data, username);
                                  } else if (widget.isPeople == true) {
                                    if (currentUser.email == data["email"]) {
                                      return Container();
                                    } else {
                                      return user(data, username);
                                    }
                                  }
                                } else if (data['username']
                                    .toString()
                                    .toLowerCase()
                                    .contains(searchText)) {
                                  if (currentUser.email == data['email']) {
                                    return Container();
                                  } else {
                                    return user(data, username);
                                  }
                                }

                                return Container();
                              }));
                    },
                  ))),
        ],
      ),
    );
  }

  Container user(Map<String, dynamic> data, username) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/waqas.jpg'),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['username'].toString(),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                data['email'].toString(),
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatDetails(
                        username: data['username'].toString(),
                        uid: data['uid'],
                        name: username),
                  ));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.chat)),
          ),
        ],
      ),
    );
  }

  void getCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
  }
}
