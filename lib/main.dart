import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:instagramclone/View/SignUp.dart';

import 'Controller/prefs.dart';
import 'View/MyHomePage.dart';
import 'View/SignIn.dart';
import 'View/SplashScreen.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  // notification
  var initAndroidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
  var initIosSetting = IOSInitializationSettings();
  var initSetting = InitializationSettings(android: initAndroidSetting, iOS: initIosSetting);
  await FlutterLocalNotificationsPlugin().initialize(initSetting);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
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

        // primarySwatch: Colors.blue,
      ),
      home: callStartPage(),
    );
  }
}

