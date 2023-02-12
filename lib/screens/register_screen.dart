import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/login.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/app_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bubble_loader/bubble_loader.dart';

class RegisterScreen extends StatefulWidget {
  static const String id ="register_screen";

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? email;
  String? password;
  bool showSpinner=false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TapGestureRecognizer _tapGestureRecognizer;

  void getLoginState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');    }
      else {
        print('User is signed in!');  }
    }
    );}

  @override
  void initState() {
    getLoginState();
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pushReplacementNamed(context, LoginScreen.id);
      };
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
      body: showSpinner
          ?
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
                         decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your Email',prefixIcon: Icon(Icons.email)),
                           ),
                      const SizedBox(height: 12,),
                      TextField(
                        obscureText: true,
                        onChanged: (value) {
                          password=value;},
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',prefixIcon: Icon(Icons.lock)),
            ),
                      const SizedBox(height: 30,),
                      AppButton(
                          color: Colors.blue.shade800, title: 'Register',
                          onPressed: () async {
                            if (email != null && password != null)
                                  {
                                    setState(() {
                                      showSpinner = true;
                                    });
                                    try {
                                      final newUser = await _auth.createUserWithEmailAndPassword(email: email!.trim(), password: password!);
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          ChatScreen.id,
                                          ModalRoute.withName(RegisterScreen.id));

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content:  const Text(" Success"),
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
                                          duration: Duration(seconds: 3),
                                          dismissDirection: DismissDirection.horizontal,
                                        ),
                                      );
                                    }
                                  }
                                  else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:  Text("Enter Required data"),
                                        backgroundColor: Colors.blue.shade300,
                                        duration: Duration(seconds: 3),
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Text("Have An Account ?",style: TextStyle(color: Colors.grey.shade800,fontSize: 16,fontWeight: FontWeight.bold)),
                                  ),
                                  TextButton(onPressed: (){
                                    Navigator.pushNamed(context, LoginScreen.id);
                                  }, child: Text("LogIn!",style: TextStyle(color: Colors.yellow.shade800,decoration:TextDecoration.underline,fontSize: 15,fontWeight: FontWeight.bold)))
                                ],),
                            ),


          ],
        ),
      ),
    );
  }
}
