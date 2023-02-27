import 'package:chat_me/auth/login_page.dart';
import 'package:chat_me/screens/chats.dart';
import 'package:chat_me/services/auth.dart';
import 'package:chat_me/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

final formKey = GlobalKey<FormState>();
String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);

String? username;
String? email;
String? password;
String? confirmPassword;
String error = '';
bool isHideText = true;

class _RegistrationPageState extends State<RegistrationPage> {
  final AuthService auth = AuthService();
  final DatabaseMethods databaseMethods = DatabaseMethods();

  void validation() async {
    if (formKey.currentState!.validate()) {
      dynamic result =
          await auth.registerWithEmailandPassword(email!, password!);

      if (result == null) {
        setState(() {
          error = "Email already in use try another one";
        });
      } else {
        setState(() {
          error = 'Account register successfully';
        });
        String uid = FirebaseAuth.instance.currentUser!.uid;
        Map<String, String> userInfo = {
          'uid': uid,
          'email': email!,
          'username': username!,
        };
        databaseMethods.uploadUserInfo(userInfo, uid);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChatPage()));
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error),
        duration: Duration(milliseconds: 1500),
        // behavior: SnackBarBehavior.floating,
      ));
    } else {
      print("Something is incorrect");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          reverse: true,
          child: Form(
            key: formKey,
            child: Container(
              child: Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 50,
                      alignment: Alignment.bottomCenter,
                      child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/signup.jpg'),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            validator: (value) {
                              if (value == "") {
                                return "Please type the username";
                              } else if (value!.length < 4) {
                                return "Username is too short (type atleast 5 characters)";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                username = val;
                              });
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.person,
                                ),
                                hintText: 'Username',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none)),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            validator: (value) {
                              if (value == "") {
                                return "Please fill the email";
                              } else if (!regExp.hasMatch(value!)) {
                                return "Invalid Email";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                prefixIcon: Icon(
                                  Icons.email,
                                ),
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.grey),
                                border: InputBorder.none)),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            obscureText: isHideText,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            validator: (value) {
                              if (value == "") {
                                return "Please fill the password";
                              } else if (value!.length < 8) {
                                return "Password is too short";
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade300,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.lock,
                              ),
                              hintText: 'Password',
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isHideText = !isHideText;
                                  });
                                  FocusScope.of(context).unfocus();
                                },
                                child: Icon(
                                  isHideText == true
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                            obscureText: isHideText,
                            onChanged: (val) {
                              setState(() {
                                confirmPassword = val;
                              });
                            },
                            validator: (value) {
                              if (value == "") {
                                return "Please fill the confirm password";
                              } else if (confirmPassword != password) {
                                return "Password doesn't match";
                              } else {
                                return null;
                              }
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              fillColor: Colors.grey.shade300,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.lock,
                              ),
                              hintText: 'Confirm Password',
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isHideText = !isHideText;
                                  });
                                  FocusScope.of(context).unfocus();
                                },
                                child: Icon(
                                  isHideText == true
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              validation();
                            },
                            child: Text("Sign up"),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          Text(
                            "Already have an account ?",
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text("Login",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w800)),
                          ),
                        ]),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
