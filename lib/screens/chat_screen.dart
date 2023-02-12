
import 'dart:async';
import 'dart:convert';
import 'package:bubble_loader/bubble_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'login.dart';
import 'notfications.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const id = 'ChatScreen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  String? typingId;
  final _fireStore = FirebaseFirestore.instance;
  String token = '';
  // dynamic messages;
  Timer? _timer;
  String? msg;
  late User user;
  bool visible = false;
  late TextEditingController controller;
  List<RemoteNotification?> notifications = [];
  void getNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        setState(() {
          notifications.add(message.notification);
        });
        print(
            'Message also contained a notification: ${message.notification!.title}');
      }
    });
  }
  @override
  void initState() {
    super.initState();
    getNotification();
    getAccessToken().then((value) => token = value.data);

    getCurrentUser();
    controller = TextEditingController();
  }
  void sendNotification(String title, String body) async {
    http.Response response = await http.post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/chatapp-97e6e/messages:send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "message": {
          "topic": "news",
          // "token": fcmToken,
          "notification": {"body": body, "title": title}
        }
      }),
    );
    print('response.body: ${response.body}');
  }
  Future<AccessToken> getAccessToken() async {
    final serviceAccount = await rootBundle.loadString(
        'assets/chatapp-97e6e-firebase-adminsdk-bjwg6-15dbc5f965.json');
    final data = await json.decode(serviceAccount);
    print(data);
    final accountCredentials = ServiceAccountCredentials.fromJson({
      "private_key_id": data['private_key_id'],
      "private_key": data['private_key'],
      "client_email": data['client_email'],
      "client_id": data['client_id'],
      "type": data['type'],
    });
    final scopes = ["https://www.googleapis.com/auth/firebase.messaging"];
    final AuthClient authclient = await clientViaServiceAccount(
      accountCredentials,
      scopes,
    )
      ..close(); // Remember to close the client when you are finished with it.

    print(authclient.credentials.accessToken);

    return authclient.credentials.accessToken;
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  void getCurrentUser() {
    try {
      user = _auth.currentUser!;
      if (user != null) {
        user = user;
        print(user.email);
      }
    } catch (e) {
      print(e);
    }
  }
  void getMessageStream() async {
    await for (var snapshot in _fireStore.collection('messages').snapshots()) {
      for (var msg in snapshot.docs) {
        print(msg.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:  Colors.lightBlue,
        actions: <Widget>[
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, NotificationsScreen.id,
                      arguments: notifications)
                      .then((value) => setState(() {
                    notifications.clear();
                  }));
                },
              ),
              notifications.isNotEmpty
                  ? Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: const BoxDecoration(
                    color: Colors.red, shape: BoxShape.circle),
                         child: Text(
                  '${notifications.length}',
                  style: const TextStyle(fontSize: 7),
                ),
              )
                  : const SizedBox(),
            ],
          ),
          IconButton(
            icon: const Icon(
              Icons.logout,

            ),
            onPressed: () {
              _auth.signOut();
              // exit(0);
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.id, (route) => false);
            },
          ),
        ],
        elevation: 7,
        automaticallyImplyLeading: false,
        title:
            Text(
              'Chat...',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white,
              ),
            ),

      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _fireStore
                    .collection('messages')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  // List<Text> messageWidgets = [];

                  if (snapshot.hasData) {
                    List<dynamic> messages = snapshot.data!.docs;

                    return Expanded(
                      child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final currentUser = user.email;
                            return MessageBubble(
                                messages: messages,
                                index: index,
                                sender: messages[index]['sender'],
                                isMe: messages[index]['sender'] == currentUser);
                          }),
                    );
                  }
                  return BubbleLoader(
                      color1: Colors.blue.shade300,
                      color2: Colors.orange.shade300,
                      bubbleGap: 12,
                      bubbleScalingFactor: 1,
                      duration: const Duration(milliseconds: 1500),
                    );

                  // final msgs = snapshot.data!.docs;
                  // for (var msg in msgs) {
                  //   final txt = msg.get('text');
                  //   final sender = msg.get('sender');
                  //   final messageWidget = Text('$txt -- $sender');
                  //   messageWidgets.add(messageWidget);
                  // }
                }),
            StreamBuilder(
                stream: _fireStore.collection('typing_users').snapshots(),
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    List<dynamic> users = snapShot.data!.docs;
                    return ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          if (users[index]['user'] != user.email) {
                            return Container(
                                color: Colors.amberAccent,
                                child: Text('${users[index]['user']}'));
                          }
                          return const SizedBox();
                        });
                  }
                  return const SizedBox();
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border:  Border(
                    bottom: BorderSide(
                      color: Colors.orange.shade600,
                      width: 2,
                    ),
                    right: BorderSide(
                      color: Colors.orange.shade600,
                      width: 2,
                    ),
                    left: BorderSide(
                      color: Colors.orange.shade600,
                      width: 2,
                    ),
                    top: BorderSide(
                      color: Colors.orange.shade600,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: kMessageTextFieldDecoration,
                        onChanged: (value) async {
                          if (_timer?.isActive ?? false) _timer?.cancel();
                          _timer =
                              Timer(const Duration(milliseconds: 500), () async {
                                if (value.isNotEmpty) {
                                  if (typingId == null) {
                                    final ref = await _fireStore
                                        .collection('typing_users')
                                        .add({'user': user.email});
                                    typingId = ref.id;
                                  }
                                } else if (controller.text.isEmpty) {
                                  _fireStore
                                      .collection('typing_users')
                                      .doc(typingId)
                                      .delete();
                                  typingId = null;
                                }
                              });
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          if (controller.text.isNotEmpty) {
                            _fireStore.collection('messages').add(
                              {
                                'text': controller.text,
                                'sender': user.email,
                                'time': DateTime.now(),
                              },
                            );
                            sendNotification(
                                'message from ${user.email}', controller.text);

                            controller.clear();
                            if (typingId != null) {
                              _fireStore
                                  .collection('typing_users')
                                  .doc(typingId)
                                  .delete();
                              visible = false;

                              typingId = null;
                            }
                          }

                          //
                          //
                          // controller.clear();
                          //
                          // _fireStore.collection('messages').add({
                          //   'text': msg,
                          //   'sender': signedInUser.email,
                          //   'time': FieldValue.serverTimestamp(),
                          // });
                          getMessageStream();
                        },
                        icon:  Icon(
                          Icons.send,
                          size: 18,
                          color: Colors.blue.shade600,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {Key? key,
        required this.messages,
        required this.index,
        required this.sender,
        required this.isMe})
      : super(key: key);

  final List messages;
  final int index;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
        isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style:  TextStyle(fontSize: 12, color: isMe? Colors.blue.shade400:Colors.orange.shade400),
          ),
          const SizedBox(
            height: 8,
          ),
          Material(
            elevation: 9,
            color: isMe ? Colors.blue :  Colors.white,
            borderRadius: isMe?
              const BorderRadius.only(topLeft: Radius.circular(25),bottomRight: Radius.circular(10))
                :
              const BorderRadius.only(topRight: Radius.circular(25),bottomLeft: Radius.circular(10)
              ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${messages[index]['text']}',
                style:  TextStyle(
                  fontSize: 24,

                  color:isMe? Colors.white: Colors.blue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
