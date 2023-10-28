import 'package:flutter/material.dart';
import 'package:quiick_chat/screens/login_screen.dart';
import 'package:quiick_chat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../Widgets/paddedButton.dart';

class WelcomeScreen extends StatefulWidget {

   static const String id ='/';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
 late AnimationController controler;
 late Animation anime; 

 @override
 void initState(){
  super.initState();
  controler= AnimationController(
    duration: Duration(seconds: 1),
    vsync: this,
     );
     anime=CurvedAnimation(parent: controler, 
     curve: Curves.decelerate);
     controler.forward();
     controler.addListener(
      (){
        setState(() {
          
        });
      }
     );
     print(anime.value);
 }

@override
void dispose(){
  
  controler.dispose();
  super.dispose();
}

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
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: anime.value*100.0,
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts:[
                    TyperAnimatedText(
                      'Flash Chat',
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                    )
                  ]
                  
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            PaddedButton(
              color: Colors.blue,
              onPress: () => Navigator.pushNamed(context, LoginScreen.id),
              text: "Log In",
            ),
           PaddedButton(
            color: Colors.blueAccent,
            onPress:()=> Navigator.pushNamed(context, RegistrationScreen.id), 
            text: "Register")
          ],
        ),
      ),
    );
  }
}


