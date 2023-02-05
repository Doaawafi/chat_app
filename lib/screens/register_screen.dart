import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/login.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/app_button.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password',prefixIcon: Icon(Icons.lock)),
              ),
              const SizedBox(height: 30,),
              AppButton(color: Colors.blue.shade800, title: 'Register',
                onPressed: () async{
                setState(() {
                  showSpinner=true;

                });
                try{
                  if(email !=null && password!=null){
                      final newUser=await _auth.createUserWithEmailAndPassword(email: email!.trim(), password: password!);
                      if(newUser.user !=null && mounted){
                        Navigator.pushNamed(context, ChatScreen.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              dismissDirection: DismissDirection.horizontal,
                              backgroundColor: Colors.blue.shade300,
                              content: const Text(' Your logged in',style: TextStyle(color: Colors.white),),
                              duration: const Duration(seconds: 3),

                            ));
                        setState(() {
                          showSpinner=true;

                        });
                         }
                      else{
                        setState(() {
                          showSpinner=false;

                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Enter required data'),
                              duration: Duration(seconds: 1),
                            ));

                      }}
                  else{
                    setState(() {
                      showSpinner=false;

                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          dismissDirection: DismissDirection.horizontal,
                          backgroundColor: Colors.red,
                          content: Text('Please Enter Required Data !!',style: TextStyle(color: Colors.white),),
                          duration: Duration(seconds: 3),

                        ));
                  }

                  }
                  catch(e){
                    setState(() {
                      showSpinner=false;

                    });
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:  Text(e.toString()),
                        duration: const Duration(seconds: 5),

                      ));
                  setState(() {
                    showSpinner=false;

                  });
                }

                },
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
      ),
    );
  }
}
