import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Controller/FireBase_Storage.dart';
import 'package:instagramclone/Controller/animation.dart';
import 'package:instagramclone/Controller/auth_service.dart';
import 'package:instagramclone/Controller/flutter_toast.dart';
import 'package:instagramclone/Controller/prefs.dart';
import 'package:instagramclone/Model/UserName.dart';
import 'package:instagramclone/View/MyHomePage.dart';

import 'SignIn.dart';



class SignUpPage extends StatefulWidget {
  static final String id="SignUpPage";
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  var isLoading = false;

  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmpasswordController = TextEditingController();

  _doSignUp(){
    String name = fullnameController.text.toString().trim();
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String confirm = confirmpasswordController.text.toString().trim();
    if (email.isEmpty || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      Utils.fireToast('Enter a valid email!') ;
      return ;
    }
    if (password.isEmpty || ! RegExp(  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(password)) {
      Utils.fireToast('Enter a valid password!') ;
      return ;
    }else{
      print(true );
    }

    if(confirm!=password){
      Utils.fireToast("Please make sure that you match your password each other");
    }
    Users user=Users(fullname:name,password: password,email: email);

    setState(() {
      isLoading = true;
    });
    AuthService.signUpUser(context, name, email, password).then((result) => {
      _getFirebaseUser(user,result),
    });
  }

  _getFirebaseUser(Users user,Map<String,dynamic> map) async {
    setState(() {
      isLoading = false;
    });

    FirebaseUser firebaseUser;
    if (!map.containsKey("SUCCESS")) {
      if (map.containsKey("ERROR_EMAIL_ALREADY_IN_USE"))
        Utils.fireToast("Email already in use");
      if (map.containsKey("ERROR"))
        Utils.fireToast("Try again later");
      return;
    }
    firebaseUser = map["SUCCESS"];
    if (firebaseUser == null) return;
    await Prefs.saveUserId(firebaseUser.uid);
    await DataService.storeUser(user);
     Navigator.pushReplacementNamed(context, MyHomePage.id);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
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
            child:Stack(children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeAnimation(
                        1.7, Text("Instagram",style: TextStyle(
                            color: Colors.grey[100],
                            fontSize: 45,
                            fontFamily: "Billabong"
                        ),),
                      ),   SizedBox(height: 20,),
                      // email
                      FadeAnimation(1.9,
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          height: 50,
                          padding: EdgeInsets.only(left: 10,right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white60.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: TextField(
                            controller: fullnameController,
                            decoration: InputDecoration(
                                border:InputBorder.none,
                                hintText: "Name",
                                hintStyle:TextStyle(color: Colors.white60,)
                            ),
                          ),


                        ),
                      ),SizedBox(height: 10,),
                      FadeAnimation(2.1,
                         Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          height: 50,
                          padding: EdgeInsets.only(left: 10,right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white60.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                                border:InputBorder.none,
                                hintText: "Email",
                                hintStyle:TextStyle(color: Colors.white60,)
                            ),
                          ),


                        ),
                      ),
                      SizedBox(height: 10,),
                      // password
                      FadeAnimation(2.3,
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          height: 50,
                          padding: EdgeInsets.only(left: 10,right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white60.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: TextField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                                border:InputBorder.none,
                                hintText: "Password",
                                hintStyle:TextStyle(color: Colors.white60,)
                            ),
                          ),


                        ),
                      ),
                      SizedBox(height: 10,),
                      // password
                      FadeAnimation(2.5,
                         Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          height: 50,
                          padding: EdgeInsets.only(left: 10,right: 10),
                          decoration: BoxDecoration(
                            color: Colors.white60.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: TextField(
                            obscureText: true,
                            controller: confirmpasswordController,
                            decoration: InputDecoration(
                                border:InputBorder.none,
                                hintText: "Conform Password",
                                hintStyle:TextStyle(color: Colors.white60,)
                            ),
                          ),


                        ),
                      ),
                      SizedBox(height: 10,),
                      FadeAnimation(2.7,
                        Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white60.withOpacity(0.2),width: 2
                            ),
                            borderRadius: BorderRadius.circular(7),
                          ),child:FlatButton(onPressed: (){
                          _doSignUp();
                        }, child:Center(child: Text("Sign Up",style: TextStyle(color: Colors.white60,fontSize: 17),),)),
                        ),
                      )

                    ],)),



                  FadeAnimation(2.9,
                     Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already you have an account",style: TextStyle(color: Colors.white,fontSize: 17)),SizedBox(width: 10,),
                          GestureDetector(
                              onTap:(){
                                Navigator.pushNamed(context, SignInPage.id);
                              },
                              child:Text("Sign In",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),)
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,)

                ],),
              isLoading?
              Center(
                child: CircularProgressIndicator(),
              ): SizedBox.shrink(),
            ],)
        ),
      ),
    );
  }
}
