import 'package:chat/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  static const String id ="chat_screen";
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth =FirebaseAuth.instance;
  final _fireStore=FirebaseFirestore.instance;
   late  User signInUser;
   String? message;
   TextEditingController textEditingController =TextEditingController();
   @override
  void initState() {
     textEditingController= TextEditingController();
    gerCurrentUser();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    textEditingController.dispose();
  }
   void gerCurrentUser(){
     try{
       final user = _auth.currentUser;
       if(user !=null){
         signInUser=user;
         print(signInUser.email);
       }
     }
         catch(e){
          print(e);
         }
   }

   // void getMessage() async{
   //    final message = await _fireStore.collection('messages').get();
   //    for(var m in message.docs){
   //      print(m.data());
   //    }
   // }
 //   void messagesStream() async{
 // await  for ( var snapShot  in  _fireStore.collection('messages').snapshots())
 // {
 //   for (var message in snapShot.docs) {
 //          print(message.data());
 //   }
 // }
 //   }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Container(
                height: 30,
                width: 30,
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // shape: BoxShape.circle,
                    image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQhG6ddRd1zgz6IrQ5ZKZL5EBHOvrnac3gxTQ&usqp=CAU',)
                  )
                ),
            ),
            const SizedBox(width: 20,),
            Flexible(
              child: Text("MessagingMe",style:GoogleFonts.montserrat(
                  color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold
              ),),
            ),

          ],
        ),
        actions: [
        IconButton(onPressed: (){
          // messagesStream();
          // getMessage();
          _auth.signOut();
          // Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context, LoginScreen.id, (route) => false);
        }, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _fireStore.collection('messages').orderBy('time').snapshots(),
              builder: (context,snapshot){
                 List<messageWidgetST> messageWidgets =[];
                 if(!snapshot.hasData){
                  return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                 final message= snapshot.data!.docs.reversed;
                 for(var m in message ){
                   final messageText= m.get('text');
                   final messageSender=m.get('sender');
                   final currentUser= signInUser.email;
                   final messageWidget= messageWidgetST(mT: messageText,mS: messageSender, isMe:currentUser==messageSender ,);

                   messageWidgets.add(messageWidget);
                 }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    children: messageWidgets,
                  ),
                );

              }),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.yellow.shade800
                )
              )
          ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    onChanged: (value){
                      // textEditingController!.text =value;
                      message=value;
                    },
                    decoration: InputDecoration(
                      hintText: "Write message here...",
                      // border: const OutlineInputBorder(
                      //   borderRadius: BorderRadius.only(topLeft:Radius.circular(5),
                      //       // topRight: Radius.circular(5)
                      //   ),
                      // ),
                      // enabledBorder:OutlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.yellow.shade800),
                      //   borderRadius: const BorderRadius.only(topLeft:Radius.circular(5),
                      //       // topRight: Radius.circular(5)
                      //   ),
                      // ),
                      // focusedBorder: OutlineInputBorder(
                      //   borderSide: BorderSide(color: Colors.blue.shade800),
                      //   borderRadius: const BorderRadius.only(topLeft:Radius.circular(5),
                      //       // topRight: Radius.circular(5)
                      //   ),
                      // ),
                    ),
                  ),
                ),
                TextButton(
                  // style: ButtonStyle(
                  //   backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue.shade800),
                  //   elevation: MaterialStateProperty.resolveWith((states) => 4),
                  //   iconSize:MaterialStateProperty.resolveWith((states) => 50),
                  //   minimumSize: MaterialStateProperty.resolveWith((states) =>Size(80, 60)),
                  //
                  // ),

                  onPressed: (){
                    print(textEditingController.text);
                    textEditingController.clear();
                    _fireStore.collection('messages').add({
                      'text':message,
                      'sender':signInUser.email,
                      'time': FieldValue.serverTimestamp(),
                    }

                    );
                  },
                  child: Text('Send',style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blue.shade800),))
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class messageWidgetST extends StatelessWidget {
   const messageWidgetST({ this.mS, this.mT,Key? key, required this.isMe}) : super(key: key);
    final  String? mT;
    final  String? mS;
    final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text('$mS',style: TextStyle( color:isMe? Colors.yellow.shade800: Colors.blue.shade800,),),
          ),
          Material(
              elevation: 7,
              color:isMe? Colors.blue.shade800 : Colors.white,
              borderRadius: isMe?
              const BorderRadius.only(topLeft: Radius.circular(25),bottomRight: Radius.circular(10)
              ): const BorderRadius.only(topRight: Radius.circular(25),bottomRight: Radius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                child: Text('$mT ',style: TextStyle( color: isMe? Colors.white: Colors.black),),
              )),
        ],
      ),
    );
  }
}
