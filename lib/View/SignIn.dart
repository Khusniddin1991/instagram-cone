import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Controller/auth_service.dart';
import 'package:instagramclone/Controller/flutter_toast.dart';
import 'package:instagramclone/Controller/prefs.dart';
import 'package:instagramclone/View/MyHomePage.dart';
import 'package:instagramclone/View/SignUp.dart';



class SignInPage extends StatefulWidget {
  static final String id="SignInPage";
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController=new TextEditingController();
  final passwordController=new TextEditingController();
  var isLoading = false;
  _doSignIn() {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if (email.isEmpty || !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email)) {
      Utils.fireToast('Enter a valid email!') ;
      print(false);
    }
    else{
      print(true);
    }
    if (password.isEmpty || ! RegExp(  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
        .hasMatch(password)) {
      Utils.fireToast('Enter a valid p!') ;
    }else{
      print(true );
    }
    setState(() {
      isLoading = true;
    });
    AuthService.signInUser(context, email, password).then((value) => {
      _getFirebaseUser(value),
    });
  }

  _getFirebaseUser(Map<String,FirebaseUser> map) async {
    setState(() {
      isLoading = false;
    });
    FirebaseUser firebaseUser;
    if (!map.containsKey("SUCCESS")) {
      if (map.containsKey("ERROR"))
        Utils.fireToast("Try again later");
      return;
    }

          firebaseUser=map["SUCCESS"];
            if(firebaseUser==null)return
            await Prefs.saveUserId(firebaseUser.uid);
              Navigator.pushReplacementNamed(context, MyHomePage.id);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
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
                    Text("Instagram",style: TextStyle(
                        color: Colors.grey[100],
                        fontSize: 45,
                        fontFamily: "Billabong"
                    ),),   SizedBox(height: 20,),
                    // email
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
                    SizedBox(height: 10,),
                    // password
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      height: 50,
                      padding: EdgeInsets.only(left: 10,right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white60.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            border:InputBorder.none,
                            hintText: "Password",
                            hintStyle:TextStyle(color: Colors.white60,)
                        ),
                      ),


                    ),
                    SizedBox(height: 10,),
                    Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white60.withOpacity(0.2),width: 2
                        ),
                        borderRadius: BorderRadius.circular(7),
                      ),child:FlatButton(onPressed: (){
                      _doSignIn();

                    }, child:Center(child: Text("Sign In",style: TextStyle(color: Colors.white60,fontSize: 17),),)),
                    )

                  ],)),



                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("don't you have an account",style: TextStyle(color: Colors.white,fontSize: 17)),SizedBox(width: 10,),
                      GestureDetector(
                          onTap:(){
                            Navigator.pushNamed(context, SignUpPage.id);
                          },
                          child:Text("Sign Up",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 17),)
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,)

              ],),
            isLoading ?
            Center(
              child: CircularProgressIndicator(),
            ): SizedBox.shrink(),
          ],)
        ),
      ) ,
    );
  }
}
