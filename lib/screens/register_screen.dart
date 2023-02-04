import 'package:chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/app_button.dart';
import '../widgets/text_field_app.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
  FirebaseAuth _auth =FirebaseAuth.instance;
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
    super.initState();}
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
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
              AppButton(color: Colors.blue.shade800, title: 'Register',
                onPressed: () async{
                setState(() {
                  showSpinner=true;

                });
                  if(email !=null && password!=null){
                    try{
                      final newUser=await _auth.createUserWithEmailAndPassword(email: email!, password: password!);
                      if(newUser.user !=null && mounted){
                        Navigator.pushNamed(context, ChatScreen.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('logged in'),
                              duration: const Duration(seconds: 1),

                            ));
                        setState(() {
                          showSpinner=false;

                        });
                         }else{
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Error'),
                              duration: const Duration(seconds: 1),
                              // action: SnackBarAction(
                              //       label: 'ACTION',
                              //           onPressed: () { },)
                            ));
                      }}
                    catch(e){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:  Text(e.toString()),
                            duration: const Duration(seconds: 1),

                          ));
                    }
                  }

                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
