


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Controller/flutter_toast.dart';
import 'package:instagramclone/View/MyFeedPage.dart';
import 'package:instagramclone/View/MyLikePage.dart';
import 'package:instagramclone/View/MyProfilePage.dart';
import 'package:instagramclone/View/MySearchPage.dart';
import 'package:instagramclone/View/MyUploadPage.dart';


class MyHomePage extends StatefulWidget {
  static final String id="MyHomePage";
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int current=0;
  PageController pageController;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  _initNotification() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Utils.showLocalNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        //print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        //print("onResume: $message");
      },
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initNotification();
    pageController=PageController();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:PageView(
        onPageChanged: (int i){
          setState(() {
            current=i;
          });
        },
        controller:pageController ,
        children: [
        MyFeedPage(pageConroller:pageController ,),
        MySearchPage(),
        MyUploadPage(pageConrollers:pageController ,),
        MyLikePage(),
        MyProfilePage()
      ],),bottomNavigationBar: CupertinoTabBar(
      onTap: (int index){
        current=index;
        pageController.animateToPage(current, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      },
      currentIndex: current,
      activeColor:  Color.fromRGBO(245, 96, 64, 1),
      items: [
        BottomNavigationBarItem(icon:Icon(Icons.home,size: 32,)),
        BottomNavigationBarItem(icon:Icon(Icons.search,size: 32,)),
        BottomNavigationBarItem(icon:Icon(Icons.add_box,size: 32,)),
        BottomNavigationBarItem(icon:Icon(Icons.favorite,size: 32,)),
        BottomNavigationBarItem(icon:Icon(Icons.account_circle,size: 32,))
      ],
    ),
    );
  }
}
