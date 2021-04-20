

import 'package:flutter/foundation.dart';

class Users {
  String uid = "";
  String fullname = "";
  String lastName = "";
  String email = "";
  String password = "";
  String img_url = "";

  String device_id = "";
  String device_type = "";
  String device_token = "";

  bool followed = false;
  int followers_count = 0;
  int following_count = 0;

  Users({this.fullname, this.email, this.password});

  Users.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        fullname = json['fullname'],
        email = json['email'],
        password = json['password'],
        img_url = json['img_url'],
        device_id = json['device_id'],
        device_type = json['device_type'],
        device_token = json['device_token'];

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'fullname': fullname,
    'email': email,
    'password': password,
    'img_url': img_url,
    'device_id': device_id,
    'device_type': device_type,
    'device_token': device_token,
  };

  @override
  bool operator ==(other) {
    return (other is Users) && other.uid == uid;
  }
}