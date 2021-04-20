
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class HttpServices{

  static Map<String,String> header={
    'content-type': 'application/json',
    'Authorization': 'key=AAAADYFvPms:APA91bGziDJKnwhEFaryCdgRK5yqEKUm7Cz5hIpw3d1GLHrQ8pNX6Inu4hpUBTSSvjQfYz9KNLEXOsce_ANrgp73rpyl0WVmKDTMUJq41okGKrfqTdysVpx3BjS7XoBuHyoJHA2Yc3wU',
  };
  static String apiPost="/fcm/send";
  static String base="fcm.googleapis.com";

  static Future<void> POST() async {

      var uri=Uri.https(base,apiPost );
      var response=await post(uri,headers:header,body:jsonEncode({

        "notification":{
          "title":"Instagram Clone",
          "body":"any of your friends put post"
        },
        "registration_ids":["e1-Ph6kUiZQ:APA91bGUmJAfFJ4f-lMHhxWfXkLe5rsABZy6k4BR8eHKJLY1wrXUV3t9UFhq29aHDpiXXGYkZ3DiTfhxM382wSNVcA-YknjKd9tUwo64ceVJ1eoq60AfTpYs5qEMa60OaQGEyInR8_yP"],
        "click_action":"FLUTTER_NOTIFICATION_CLICK"

      }));
      if(response.statusCode==200||response.statusCode==201) {
        String h = response.body;
        print(h);
      }else{
        print("there is no data");
      }



  }






}