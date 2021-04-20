import 'dart:io';
// import 'dart:js';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/Controller/FireBase_Storage.dart';
import 'package:instagramclone/Controller/file_data.dart';
import 'package:instagramclone/Controller/file_data.dart';
import 'package:instagramclone/Controller/file_data.dart';
import 'package:instagramclone/Controller/flutter_toast.dart';
import 'package:instagramclone/Model/Post_Model.dart';
import 'package:instagramclone/Controller/auth_service.dart';
import 'package:instagramclone/Model/UserName.dart';
import 'package:instagramclone/View/MySearchPage.dart';


class UserProfilePage extends StatefulWidget {
  @override
  Users data;
  List<Post > need;
  UserProfilePage({this.data,this.need});


  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // User
  int axisCount=1;
  String fullname='';
  String email='';
  String photo_url='';
  bool isloading=false;
  int counter=0;
  int followers_count = 0;
  int following_count = 0;

  List<Post > items=List();
  void _apiLoader(Users someone)async{
    List<Post> infos=await DataService.loadingPost(someone);
    setState(() {
      items=infos;
    });
  }
  // for profile picture

 void show(){
   setState(() {
     this.fullname=widget.data.fullname;
     this.photo_url=widget.data.img_url;
     this.email=widget.data.email;
     this.following_count=widget.data.following_count;
     this.followers_count=widget.data.followers_count;
     // this.items=widget.need;


   });
 }
  void _apiFollowUser(Users someone) async{
    setState(() {
      isloading = true;
    });
    await DataService.followUser(someone);
    setState(() {
      someone.followed = true;
      isloading = false;
    });
    DataService.storePostsToMyFeed(someone);
  }

  void _apiUnfollowUser(Users someone) async{
    setState(() {
      isloading = true;
    });
    await DataService.unfollowUser(someone);
    setState(() {
      someone.followed = false;
      isloading = false;
    });
    DataService.removePostsFromMyFeed(someone);
  }
@override
  void initState() {
    super.initState();
    _apiLoader(widget.data);
    show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("UsersProfile",style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontFamily: "Billabong"
          ),),elevation: 0,centerTitle: true,
          actions: [
            IconButton(icon:Icon(Icons.exit_to_app,color: Colors.red,), onPressed:(){
              Navigator.pop(context);
            })
          ],
        ),
        backgroundColor: Colors.white,
        body:Stack(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(children: [
                  Container(
                      padding:EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(70),
                          border: Border.all(width: 1.5,color: Color.fromRGBO(193, 53, 132, 1))

                      ),
                      child: photo_url==null||photo_url.isEmpty?ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image(
                          image: AssetImage("asset/instagramPicture.png"),
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ): ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(photo_url, width: 70,
                            height: 70,
                            fit: BoxFit.cover,)
                      )),
                  Positioned(
                    left:13,
                    top: 13,
                    child: Container(
                      width:  79,
                      height: 79 ,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          IconButton(icon: Icon(Icons.add_circle,color: Colors.purple,),onPressed: (){
                            // _showPicker(context);
                          },)


                        ],),
                    ),
                  )
                ],),
                SizedBox(height: 10,),
                Text(fullname.toUpperCase(),style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold),),
                SizedBox(height: 3,),
                Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(width: 1,color: Color.fromRGBO(193, 53, 132, 1))
                  ),
                  child: Center(
                    child:widget.data .followed ? Text("Following") : Text("Follow"),
                  ),
                ),
                // My accounts
                Container(
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(counter.toString().toUpperCase(),style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold),),
                              SizedBox(height: 3,),
                              Text("Post".toUpperCase(),style: TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.normal),),
                            ],),
                        ),
                      ),
                      Container(width: 1,height: 20,color: Colors.black.withOpacity(0.5),),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(followers_count.toString().toUpperCase(),style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold),),
                              SizedBox(height: 3,),
                              Text("Followers".toUpperCase(),style: TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.normal),),
                            ],),
                        ),
                      ),
                      Container(width: 1,height: 20,color: Colors.black.withOpacity(0.5),),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(following_count.toString().toUpperCase(),style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold),),
                              SizedBox(height: 3,),
                              Text("Following".toUpperCase(),style: TextStyle(color: Colors.black54,fontSize: 14,fontWeight: FontWeight.normal),),
                            ],),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                axisCount = 1;
                              });
                            },
                            icon: Icon(Icons.list_alt),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                axisCount = 2;
                              });
                            },
                            icon: Icon(Icons.grid_view),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child:GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: axisCount), itemCount:items.length,itemBuilder: (_,i){
                  return makeitem(items[i]);
                }))



              ],),
          ),isloading?Center(child: CircularProgressIndicator(),):SizedBox.shrink()
        ],));
  }

  makeitem(Post item) {
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.all( 5),
            child: Column(
              children: [
                Expanded(child:CachedNetworkImage(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                  imageUrl:items.first.img_post,
                  placeholder: (_,url)=>CircularProgressIndicator(),
                  errorWidget:(_,url,error)=>Icon(Icons.error),
                ), ),
                SizedBox(height: 3,),
                Text(items.first.caption),

              ],
            ),
          ),

        ],
      ),
    );
  }

}







