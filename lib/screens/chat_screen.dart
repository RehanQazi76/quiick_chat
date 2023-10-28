import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiick_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart  ';
import 'package:timeago/timeago.dart' as timeago;

class ChatScreen extends StatefulWidget {
  static const String id='/chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? message;
  TextEditingController messages=TextEditingController();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          
          children: <Widget>[

            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection("messages").orderBy("createdOn").snapshots(),
              builder:(context,snapshot) {
                if(!snapshot.hasData){
                  return CircularProgressIndicator(backgroundColor: Colors.white,);
                }
                List <BubbleMessage> messageWidgets=[];
                bool check;
                final List<QueryDocumentSnapshot> lists=snapshot.data!.docs.reversed.toList() ;
                for(var list in lists){
                  if(currentUser!.email.toString() !=list["sender"].toString()){
                    check=false;
                  }
                  else{
                    check=true;
                  }
                  String Time=TimeOfDay.fromDateTime(list["createdOn"].toDate()).toString();
                  final messageWidget=BubbleMessage(sender: list["sender"].toString(),message: list["message"].toString(),createdOn: Time.substring(10,15),check:check);

                  messageWidgets.add(messageWidget);
                }             
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: EdgeInsets.only(bottom: 15),
                    
                    children: messageWidgets,
                  ),
                );
              }
              ),

            Container(
              
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                verticalDirection: VerticalDirection.up,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messages,
                      onChanged: (value) {
                        message=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messages.clear();
                      if(message!=""){
                      print(message);
                      var data ={
                        "message":message,
                        "sender":currentUser!.email,
                        "createdOn": DateTime.now()                        
                      };
                      print(DateTime.now());
                      
                      _firestore.collection("messages").add(data);}
                      message="";
                      
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

class BubbleMessage extends StatelessWidget {
  const BubbleMessage({this.sender,this.message,this.createdOn,this.check});
  final sender;
  final message;
  final createdOn;
  final check;

  @override
  Widget build(BuildContext context) {
    return Column(
                    crossAxisAlignment:check? CrossAxisAlignment.end:CrossAxisAlignment.start,
                    children: [
                      Text(sender,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      ),
                      SizedBox(height: 3.0,),
                      Material(
                        elevation: 5,
                        
                        
                        child: Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color:check? Colors.blue:Colors.white,
                            borderRadius:check? BorderRadius.only(topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) ): BorderRadius.only(topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) ),
                      
                            
                          ),
                          child: Column(
                            crossAxisAlignment: check? CrossAxisAlignment.end:CrossAxisAlignment.start,
                            children: [
                              Text(message,
                              style: TextStyle(fontSize: 35,
                              color: check? Colors.white:Colors.black,
                              
                              ),
                              ),
                               SizedBox(height: 5,),
                        Text(createdOn,
                      style: TextStyle(
                        fontSize: 20,
                        color: check? Colors.white:Colors.black,
                      ),
                      ),
                            ],
                          ),
                          
                          ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                       
                    ],
                  );;
  }
}