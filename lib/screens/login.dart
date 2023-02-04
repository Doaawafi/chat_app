import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/register_screen.dart';
import 'package:chat/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            Image.asset('assets/img.png'),
            const SizedBox(height: 25,),
            TextField(
              keyboardType: TextInputType.emailAddress,

              onChanged: (value) {
                email=value;
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
            const SizedBox(height: 10,),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Text( "Don't Have An Account ?",style: TextStyle(color: Colors.grey.shade800,fontSize: 16,fontWeight: FontWeight.bold)),
                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, RegisterScreen.id);
                  }, child: Text("Create Account!",style: TextStyle(color: Colors.blue.shade800,decoration:TextDecoration.underline,fontSize: 15,fontWeight: FontWeight.bold)))
                ],),
              ),
            ),


          ],
        ),
      ),
    );
  }
}


