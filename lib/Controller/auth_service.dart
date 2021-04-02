
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagramclone/Controller/prefs.dart';
import 'package:instagramclone/View/SignIn.dart';

class AuthService{
  static final _auth = FirebaseAuth.instance;

  static Future< Map<String,FirebaseUser>> signInUser(BuildContext context, String email, String password) async {
    Map<String,FirebaseUser> map=new Map();
    try {
      _auth.signInWithEmailAndPassword(email: email, password: password);
      final FirebaseUser user = await _auth.currentUser();
      map.addAll({"SUCCESS": user});
      print(user.toString());
    } catch (e) {
      print(e.toString());
      map.addAll({"ERROR": null});
    }
    return map  ;
  }

  static Future<Map<String,FirebaseUser>> signUpUser(BuildContext context, String name, String email, String password) async {
    Map<String,FirebaseUser> map=new Map();
    try {
      var authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = authResult.user;
      map.addAll({"SUCCESS": user});
     print(map);
    } catch (error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          map.addAll({"ERROR_EMAIL_ALREADY_IN_USE": null});
          break;
        default:
          map.addAll({"ERROR": null});
      }}
    return map;
  }

  static void signOutUser(BuildContext context) {
    _auth.signOut();
    Prefs.removeUserId().then((value) {
      Navigator.pushReplacementNamed(context, SignInPage.id);
    });
  }
}