import 'package:bubble_loader/bubble_loader.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/register_screen.dart';
import 'package:chat/widgets/app_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants.dart';


class LoginScreen extends StatefulWidget {
  static const String id ="login_screen";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth= FirebaseAuth.instance;
  late String email;
  late String password;
  late TapGestureRecognizer _tapGestureRecognizer;
  bool showSpinner=false;

  // void getLoginStates() {
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     if (user == null) {
  //       print('User is currently signed out!');
  //     } else {
  //       print('User is signed in!');
  //     }
  //   });
  // }
  @override
  void initState() {
    // getLoginStates();
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pushReplacementNamed(context, RegisterScreen.id);
      };
    super.initState();
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: showSpinner?
       BubbleLoader(
        color1: Colors.blue.shade300,
        color2: Colors.orange.shade300,
        bubbleGap: 12,
        bubbleScalingFactor: 1,
        duration: const Duration(milliseconds: 1500),
      )
          :
       Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/img.png'),
            const SizedBox(height: 25,),
            TextField(
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email=value;
                },
              decoration:
              kTextFieldDecoration.copyWith(hintText: 'Enter your Email',prefixIcon: Icon(Icons.email)),
            ),
            const SizedBox(height: 12,),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password=value;
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',prefixIcon: const Icon(Icons.lock)),
            ),
            const SizedBox(height: 30,),
            AppButton(
                color: Colors.yellow.shade800, title: 'Sign In',
                onPressed: () async {
                  if (email != null && password != null)
                  {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                      await _auth.signInWithEmailAndPassword(
                          email: email.trim(),
                          password: password.trim());
                      Navigator.pushNamedAndRemoveUntil(
                          context,
                          ChatScreen.id,
                          ModalRoute.withName(LoginScreen.id));

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const  Text("Logged in"),
                          backgroundColor: Colors.blue.shade300,
                          duration: const Duration(seconds: 3),
                          dismissDirection: DismissDirection.horizontal,
                        ),
                      );
                       }
                    catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:  Text("$e"),
                          backgroundColor: Colors.red.shade300,
                          duration: const Duration(seconds: 3),
                          dismissDirection: DismissDirection.horizontal,
                        ),
                      );
                    }
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:  const Text("Enter Required data"),
                        backgroundColor: Colors.blue.shade300,
                        duration:const  Duration(seconds: 3),
                        dismissDirection: DismissDirection.horizontal,
                      ),
                    );
                  }
                  setState(() {
                    showSpinner = false;
                  });

                  // print(pass);
                  // print(email);
                }
                ),
            const SizedBox(height: 10,),
            Flexible(
              child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Padding(
                  padding: const EdgeInsets.only(left: 55),
                  child: Text( "Don't Have An Account ?",style: TextStyle(color: Colors.grey.shade800,fontSize: 12,fontWeight: FontWeight.bold)),
                ),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, RegisterScreen.id);
                }, child: Text("Create Account!",style: TextStyle(color: Colors.blue.shade800,decoration:TextDecoration.underline,fontSize: 13,fontWeight: FontWeight.bold)))
              ],),
            ),


          ],
        ),
      ),
    );
  }


}


