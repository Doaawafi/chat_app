import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/login.dart';
import 'package:chat/screens/register_screen.dart';
import 'package:chat/screens/welcom_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
FirebaseAuth _auth =FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: _auth.currentUser !=null? ChatScreen.id: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id:(context) => const WelcomeScreen(),
        LoginScreen.id:(context) => const LoginScreen(),
        RegisterScreen.id:(context) => const RegisterScreen(),
        ChatScreen.id:(context) => const ChatScreen(),
      },
    );
  }
}


