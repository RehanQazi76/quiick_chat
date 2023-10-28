import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiick_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart  ';

class ChatScreen extends StatefulWidget {
  static const String id='/chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? message;
  final _firestore= FirebaseFirestore.instance;
  final _auth=FirebaseAuth.instance;
   late final User? currentUser;
  void getCurrUser()async{
    try{
      final used= _auth.currentUser;
      if(used!=null){
        currentUser=used;
        print(currentUser!.email);
      }
final user=   _auth.authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  }
  );
  print(user);
    }catch(e){

    }
  
  }
  @override
  void initState(){
    super.initState();
    getCurrUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async{
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: ListView(
          
          children: <Widget>[

            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("messages").snapshots(),
              builder:(context,snapshot) {
                if(!snapshot.hasData){
                  return CircularProgressIndicator(backgroundColor: Colors.white,);
                }
                List <Column> messageWidgets=[];

                final List<QueryDocumentSnapshot> lists=snapshot.data!.docs.toList() ;
                for(var list in lists){
                  final messageWidget=Column(
                    children: [
                      Text(list["sender"]),
                      SizedBox(height: 3.0,),
                      Text(list["message"]),
                    ],
                  );
                  messageWidgets.add(messageWidget);
                }
                
              
                

                
               
                return Column(
                  children: messageWidgets,
                );
              }
              ),

            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(

                      onChanged: (value) {
                        message=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print(message);
                      var data ={
                        "message":message,
                        "sender":currentUser!.email,
                      };
                      _firestore.collection("messages").add(data);
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
    );
  }
}
