import 'package:chat_me/main.dart';
import 'package:chat_me/screens/chat_details.dart';
import 'package:chat_me/screens/widgets/chat_body.dart';
import 'package:chat_me/services/database.dart';
import 'package:chat_me/services/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class chatHeader extends StatefulWidget {
  const chatHeader({
    Key? key,
  }) : super(key: key);

  @override
  State<chatHeader> createState() => _chatHeaderState();
}

class _chatHeaderState extends State<chatHeader> {
  QuerySnapshot? querySnapshot;
  var currentUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 105,
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(left: 10),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseApi().fetchUserfromFirebase(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 5,
                                  right: 10,
                                ),
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      radius: 30,
                                      child: Icon(
                                        Icons.add,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Add Story',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: ((context, index) {
                                        var data = snapshot.data!.docs[index]
                                            .data() as Map<String, dynamic>;
                                        if (currentUser.email ==
                                            data['email']) {
                                          return Container();
                                        } else {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ChatDetails(
                                                            username: data[
                                                                'username'],
                                                            uid: data['uid']),
                                                  ));
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Column(
                                                children: [
                                                  CircleAvatar(
                                                      radius: 30,
                                                      backgroundImage: NetworkImage(
                                                          'https://celebsupdate.com/wp-content/uploads/2020/05/Beautiful-Young-Pakistani-Actresses.jpg')),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 70,
                                                    child: Text(
                                                      data['username'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: true,
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      })),
                                ],
                              ),
                            ],
                          ),
                        );
                }),
          ),
        ),
      ],
    );
  }

  void getCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser;
  }
}
