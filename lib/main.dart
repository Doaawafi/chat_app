import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/login.dart';
import 'package:chat/screens/notfications.dart';
import 'package:chat/screens/register_screen.dart';
import 'package:chat/screens/welcom_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
void main() async{
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('User granted permission: ${settings.authorizationStatus}');
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.subscribeToTopic("news");
  runApp(const MyApp());
}
FirebaseAuth _auth =FirebaseAuth.instance;
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  void getFcm() async{
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print('FcmToken: $fcmToken');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getFcm();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: _auth.currentUser !=null? ChatScreen.id: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id:(context) => const WelcomeScreen(),
        LoginScreen.id:(context) => const LoginScreen(),
        RegisterScreen.id:(context) => const RegisterScreen(),
        ChatScreen.id:(context) =>  const ChatScreen(),
        NotificationsScreen.id:(context) =>  const NotificationsScreen(),
      },
    );
  }
}


