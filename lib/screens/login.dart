import 'package:chat/screens/chat_screen.dart';
import 'package:chat/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


import '../constants.dart';
import '../widgets/text_field_app.dart';


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
  bool showSpinner=false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhG6ddRd1zgz6IrQ5ZKZL5EBHOvrnac3gxTQ&usqp=CAU'),
            const SizedBox(height: 25,),
            TextField(
              keyboardType: TextInputType.emailAddress,

              onChanged: (value) {
                email=value;

                //Do something with the user input.
              },
              decoration:
              kTextFieldDecoration.copyWith(hintText: 'Enter your Email'),
            ),
            const SizedBox(height: 12,),
            TextField(
              obscureText: true,
              onChanged: (value) {
                password=value;
                //Do something with the user input.
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password'),
            ),
            const SizedBox(height: 30,),
            AppButton(
                color: Colors.yellow.shade800, title: 'Sign In',
                onPressed: ()async{
                  setState(() {
                    showSpinner=true;

                  });
                  try{
                    if(email !=null && password !=null){
                      final user= await _auth.signInWithEmailAndPassword(email: email, password: password);
                      if(user !=null){
                        Navigator.pushNamed(context,ChatScreen.id);
                        setState(() {
                          showSpinner=false;

                        });
                      }
                    }

                  }catch(e){
                    print(e);
                  }
                }),

          ],
        ),
      ),
    );
  }
}


