import 'package:chat_me/auth/registration_page.dart';
import 'package:chat_me/model/user.dart';
import 'package:chat_me/screens/chats.dart';
import 'package:chat_me/screens/home_page.dart';
import 'package:chat_me/screens/login_page.dart';
import 'package:chat_me/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(StreamProvider<UserId?>.value(
    value: AuthService().user,
    initialData: null,
    child: MaterialApp(
      initialRoute: './',
      routes: {
        './': ((context) => MyApp()),
        '/registration': ((context) => RegistrationPage()),
        '/chats': ((context) => ChatPage())
      },
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserId?>(context);
    return user == null ? LoginPage() : HomePage();
  }
}
