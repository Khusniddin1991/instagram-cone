

import 'dart:async';
import 'dart:async';
import 'dart:async';
import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramclone/Controller/prefs.dart';
import 'package:instagramclone/Model/UserName.dart';

class DataService{
  static final _fireStore=Firestore.instance;


  static String folder_user="users";

  static Future storeUser(Users user)async{
    user.uid=await Prefs.loadUserId();
    return _fireStore.collection(folder_user).document(user.uid).setData(user.toJson());
  }

  static Future <Users> loadUser() async{
    String uid=await Prefs.loadUserId();
    var value=await _fireStore.collection(folder_user).document(uid).get();
    Users user=Users.fromJson(value.data);
    return user;
  }

  static Future updateUser(Users user)async{
    String uid=await Prefs.loadUserId();
    return  _fireStore.collection(folder_user).document(uid).updateData(user.toJson());

  }

  static Future<List<Users>> searchUser(String keyword)async{
    List<Users> items=List();

    var querySnapshot = await _fireStore.collection(folder_user).orderBy("email").startAt([keyword]).getDocuments();
    print(querySnapshot.documents.length);
    String uid=await Prefs.loadUserId();
    querySnapshot.documents.forEach((result) {
      Users newUser = Users.fromJson(result.data);
      if (newUser.uid != uid) {
        items.add(newUser);
      }
      return items;
    });
  }
}