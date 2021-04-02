import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/View/SignUp.dart';

import 'Controller/prefs.dart';
import 'View/MyHomePage.dart';
import 'View/SignIn.dart';
import 'View/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Widget callStartPage() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          Prefs.saveUserId(snapshot.data.uid);
          return SplashScreen();
        } else {
          Prefs.removeUserId();
          return SignInPage();
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        SignUpPage.id:(ctx)=>SignUpPage(),
        SignInPage.id:(ctx)=>SignInPage(),
        SplashScreen.id:(ctx)=>SplashScreen(),
        MyHomePage.id:(ctx)=>MyHomePage()
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: callStartPage(),
    );
  }
}

