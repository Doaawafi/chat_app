import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chat/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_button.dart';
import 'login.dart';


class WelcomeScreen extends StatefulWidget {
  static const String id ="welcome_screen";

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}


class _WelcomeScreenState extends State<WelcomeScreen> {
  // @override
  // void initState() {
  //   // FirebaseAuth.instance.authStateChanges().listen((user) {
  //   //   if(user !=null){
  //   //     Navigator.pushNamedAndRemoveUntil(context, ChatScreen.id, (route) => false)   ;   }
  //   // });
  //   // TODO: implement initState
  //   super.initState();
  // }
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/img.png'),
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    "MessagingMe App...",
                    textStyle:GoogleFonts.montserrat(
                  color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold
                       ),
                    speed: const Duration(milliseconds: 200),
                  ),
                ],

                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 150),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
              const SizedBox(height: 40,),
              AppButton(color: Colors.yellow.shade900, title: 'Sign In', onPressed: () { Navigator.pushReplacementNamed(context, LoginScreen.id); },),
              const SizedBox(height: 20,),
              AppButton(color: Colors.blue.shade900, title: 'Sign Up', onPressed: () { Navigator.pushReplacementNamed(context, RegisterScreen.id); },),

            ],
          ),
        ),
      ),
    );
  }
}

