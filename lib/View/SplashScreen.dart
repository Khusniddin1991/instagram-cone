


import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Controller/prefs.dart';
import 'package:instagramclone/View/MyHomePage.dart';
import 'package:instagramclone/View/SignIn.dart';


class SplashScreen extends StatefulWidget {
  static final String id="SplashScreen";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

 next(){
   Timer(Duration(seconds: 2),(){
     Navigator.pushReplacementNamed(context,MyHomePage.id );
   });
 }
  _initNotification() {
    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print(token);
      Prefs.saveFCM(token);
    });
  }
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    next();
    _initNotification();
 }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,
             colors: [
               Color.fromRGBO(252, 175, 69, 1),
               Color.fromRGBO(245, 96, 64, 1)
             ]

           )
         ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            Expanded(child:Center(child: Text("Instagram",style: TextStyle(
              color: Colors.grey[100],
              fontSize: 45,
              fontFamily: "Billabong"
            ),),)),
            Text("All rights reserved",style: TextStyle(color: Colors.grey,fontSize: 16),),
            SizedBox(height: 10,)
          ],
        ),
      )
    );
  }
}
