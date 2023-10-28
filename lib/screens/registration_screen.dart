import 'package:flutter/material.dart';
import 'package:quiick_chat/Widgets/paddedButton.dart';
import 'package:quiick_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quiick_chat/screens/chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id='/register';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth=FirebaseAuth.instance;
  String email='';
  String password='';
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
            Container(
              height: 200.0,
              child: Image.asset('images/logo.png'),
            ),
            const SizedBox(
              height: 48.0,
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                email=value;
              },
              decoration: KboxDecoration,
            ),
            const SizedBox(
              height: 8.0,
            ),
            TextField(
              
              style: TextStyle(
                color: Colors.black),
              obscureText: true,
              onChanged: (value) {
                password=value;
              },
              decoration:KboxDecoration.copyWith(hintText: "Enter your Pasword"),
            ),
            const SizedBox(
              height: 24.0,
            ),
           PaddedButton(color: Colors.blueAccent, 
           onPress: () async {
           try{ 
            final User =await _auth.createUserWithEmailAndPassword(email: email, password: password);
            if(User!=null){
              Navigator.pushNamed(context, ChatScreen.id);

            }
           
           }catch(e){
            print("error");
            print(e);
           }

           },
            text: "Register")
          ],
        ),
      ),
    );
  }
}
