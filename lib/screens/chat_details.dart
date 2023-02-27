import 'package:chat_me/auth/registration_page.dart';
import 'package:chat_me/screens/widgets/message.dart';
import 'package:chat_me/services/firebase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatDetails extends StatefulWidget {
  const ChatDetails({Key? key, this.username, this.uid, this.name})
      : super(key: key);
  final String? username, uid, name;
  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  var userId;
  @override
  Widget build(BuildContext context) {
    userId = widget.uid;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pinkAccent,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Row(children: [
            SizedBox(
              child: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            CircleAvatar(
              backgroundImage: AssetImage('assets/waqas.jpg'),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username.toString(),
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  'Online',
                  style: TextStyle(fontSize: 13, color: Colors.white70),
                )
              ],
            ),
          ]),
          actions: [
            SizedBox(
              width: 50,
              child: Icon(Icons.call),
            )
          ],
        ),
        body: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats/$userId/messages')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final messages = snapshot.data!.docs;
                    return messages.length == 0
                        ? Expanded(
                            child: Center(
                              child: Text(
                                'Say Hi to ${widget.username}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                reverse: true,
                                shrinkWrap: true,
                                itemCount: messages.length,
                                itemBuilder: ((context, index) {
                                  List data =
                                      messages.map((e) => e.data()).toList();

                                  bool isMe =
                                      data[index]['sender'] != widget.name;
                                  return Row(
                                      mainAxisAlignment: !isMe
                                          ? MainAxisAlignment.start
                                          : MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                            minWidth: 20,
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                20,
                                          ),
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: !isMe
                                                ? Colors.grey.shade300
                                                : Color.fromARGB(
                                                    255, 49, 103, 50),
                                          ),
                                          child: Text(
                                            data[index]['message'],
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                              color: !isMe
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        )
                                      ]);
                                })),
                          );
                  }
                  return Container();
                })),
            chat_input_field(username: widget.username, userId: userId),
          ],
        ),
      ),
    );
  }
}

class chat_input_field extends StatefulWidget {
  const chat_input_field(
      {Key? key, required this.username, required this.userId})
      : super(
          key: key,
        );

  final String? username, userId;
  @override
  State<chat_input_field> createState() => _chat_input_fieldState();
}

class _chat_input_fieldState extends State<chat_input_field> {
  TextEditingController messageController = TextEditingController();
  String message = '';

  void sendMessage() async {
    // FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      message = messageController.text;
    });
    messageController.clear();
    // FirebaseAuth.instance.currentUser
    await FirebaseApi.uploadMessage(widget.username, widget.userId, message);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                controller: messageController,
                autocorrect: true,
                enableSuggestions: true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                    hintText: 'Write a reply', border: InputBorder.none),
                onChanged: (value) {
                  setState(() {
                    message = value;
                  });
                },
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(Icons.sentiment_satisfied_alt),
          SizedBox(
            width: 5,
          ),
          Icon(Icons.photo),
          SizedBox(
            width: 5,
          ),
          Icon(Icons.attachment),
          SizedBox(
            width: 5,
          ),
          GestureDetector(
              onTap: message.trim().isEmpty ? null : sendMessage,
              child: Icon(Icons.send)),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
