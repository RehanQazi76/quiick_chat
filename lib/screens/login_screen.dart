import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiick_chat/Widgets/paddedButton.dart';
import 'package:quiick_chat/constants.dart';
import 'package:quiick_chat/screens/chat_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String id='/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email='';
  String password='';
  final _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              keyboardType:TextInputType.emailAddress ,
              onChanged: (value) {
                email=value;
              },
              decoration:KboxDecoration,
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              obscureText: true,
              onChanged: (value) {
                password=value;
              },
              decoration:KboxDecoration.copyWith(hintText: "Enter Your Password")
            ),
            SizedBox(
              height: 24.0,
            ),
           PaddedButton(color: Colors.blueAccent,
            onPress: ()async{

              try {
                  final credential = await _auth.signInWithEmailAndPassword(
                    email: email,
                    password: password,
                  );
                  if(credential!=null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print(e);
               }
               

            }, 
            text: "Log IN")
          ],
        ),
      ),
    );
  }
}
