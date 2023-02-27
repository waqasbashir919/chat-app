import 'package:chat_me/screens/chats.dart';
import 'package:chat_me/screens/home_page.dart';
import 'package:chat_me/services/auth.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

final GlobalKey<FormState> formKey = GlobalKey<FormState>();
String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
String? email;

String? password;
String error = '';
bool isHideText = true;

class _LoginPageState extends State<LoginPage> {
  final AuthService auth = AuthService();

  void validation() async {
    final FormState form = formKey.currentState!;
    if (formKey.currentState!.validate()) {
      dynamic result = await auth.signInWithEmailandPassword(email!, password!);
      if (result == null) {
        setState(() {
          error = "User not found";
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(error),
          duration: Duration(milliseconds: 1500),
          // behavior: SnackBarBehavior.floating,
        ));
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
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
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    alignment: Alignment.bottomCenter,
                    child: Image(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/login.jpg')),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                          validator: (value) {
                            if (value == "") {
                              return "Please fill the email box";
                            } else if (!regExp.hasMatch(value!)) {
                              return "Invalid email format";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade300,
                              filled: true,
                              prefixIcon: Icon(Icons.email),
                              hintText: "Email",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          obscureText: isHideText,
                          validator: (value) {
                            if (value == "") {
                              return "Please type password";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.grey.shade300,
                              filled: true,
                              prefixIcon: Icon(Icons.lock),
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isHideText = !isHideText;
                                  });
                                },
                                child: Icon(
                                  isHideText == true
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text("Login"),
                            onPressed: () async {
                              print(email);
                              validation();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("Don't have an account?"),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/registration');
                              },
                              child: Text(
                                "Create an account",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w800),
                              ),
                            )
                          ],
                        ),
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
