import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bubble/bubble.dart';

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _textControler = TextEditingController();

  String measageText;
  String email;

  /*todo Why does that do? why it can't be user = _auth.currentUser */
  get user => _auth.currentUser;

  bool spinerState = false;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        email = user.email;
      }
    });
    super.initState();
  }

  void signOut() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      spinerState = false;
    });
    _auth.signOut();
    Navigator.pushNamed(context, '/');
  }

/*  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print('${message['message']} sended by ${message['sender']}');
      }
    }
  }*/

  var testWigets;

  Widget bubblesBuilder({String messageText, String messageSender, String currentUser}) {
    BubbleNip nipDirection;
    Alignment alignmentBubble;
    TextAlign alignmentSender;
    Color bubbleColor;

    if (email != messageSender) {
      nipDirection = BubbleNip.leftTop;
      alignmentBubble = Alignment.topLeft;
      alignmentSender = TextAlign.left;
      bubbleColor = Colors.lightGreen.shade100;

    }else{
      nipDirection = BubbleNip.rightTop;
      alignmentBubble = Alignment.topRight;
      alignmentSender = TextAlign.right;
      bubbleColor = Colors.lightGreen.shade900;
    }
    final bubbleWidget = Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            messageSender,
            style: TextStyle(color: Colors.grey),
            textAlign: alignmentSender,
          ),
          Bubble(
            margin: BubbleEdges.only(top: 10),
            stick: true,
            alignment: alignmentBubble,
            nip: nipDirection,
            color: bubbleColor,
            child: Text(
              messageText,
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 10.0)
        ],
      ),
    );
    return bubbleWidget;
  }

  /*if (email == messageSender) {
  nipDirection = BubbleNip.rightTop;
  alignmentBubble = Alignment.topRight;
  alignmentSender = TextAlign.right;
  } else {
  nipDirection = BubbleNip.leftTop;
  alignmentBubble = Alignment.topLeft;
  alignmentSender = TextAlign.left;
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.close), onPressed: signOut),
        ],
        title: Row(
          children: [
            Text('Online-Tribes'),
            /*Icon(Icons.)*/
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
      body: ModalProgressHUD(
        inAsyncCall: spinerState,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshots) {
                  List<Widget> messagesWigets = [];
                  if (!snapshots.hasData) {
                    return Center(
                      child: Text(
                        'Data not available',
                      ),
                    );
                  }

                  final documents = snapshots.data.docs;
                  dynamic tmpBubbleWidget;
                  documents.forEach((element) {
                    tmpBubbleWidget = bubblesBuilder(
                        messageSender: element['sender'],
                        messageText: element['message'],
                        currentUser: email);
                  });
                  /*
                    final messageText = element['message'];
                    final messageSender = element['sender'];
                    if (email == messageSender) {
                      nipDirection = BubbleNip.rightTop;
                      alignmentBubble = Alignment.topRight;
                      alignmentSender = TextAlign.right;
                    } else {
                      nipDirection = BubbleNip.leftTop;
                      alignmentBubble = Alignment.topLeft;
                      alignmentSender = TextAlign.left;
                    }

                    final bubbleWidget = Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              messageSender,
                              style: TextStyle(color: Colors.grey),
                              textAlign: alignmentSender,
                            ),
                            Bubble(
                              margin: BubbleEdges.only(top: 10),
                              stick: true,
                              alignment: alignmentBubble,
                              nip: nipDirection,
                              color: Color.fromRGBO(225, 255, 199, 1.0),
                              child: Text(
                                messageText,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 10.0)
                          ],
                        ));
                    messagesWigets.add(bubbleWidget);
                  });*/
                  testWigets = messagesWigets.length;
                  return Expanded(
                    child: ListView.builder(
                        reverse: true,
                        shrinkWrap: true,
                        itemCount: documents.length,
                        itemBuilder: (context, index) {
                          final document = documents[index];
                          return bubblesBuilder(
                              messageSender: document['sender'],
                              messageText: document['message'],
                              currentUser: email);
                        }),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(bottom: 20.0),
                decoration: kMessageContainerDecoration.copyWith(
                    border: Border.all(width: 2.0, color: Colors.blue)),
                child: Row(
                  /*crossAxisAlignment: CrossAxisAlignment.center,*/
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _textControler,
                        onChanged: (value) {
                          measageText = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (measageText != null) {
                          await _firestore.collection('messages').add({
                            "timestamp": FieldValue.serverTimestamp(),
                            'message': measageText,
                            /*todo why I couldn t use directly user.email;*/
                            'sender': email
                          });
                        } else {
                          print(' write something dummy');
                        }
                        _textControler.clear();
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
