import 'dart:io';

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


class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  File _image;
  int axisCount=1;
  String fullname='';
  String email='';
  String photo_url='';
  bool isloading=false;
  int counter=0;
  int followers_count = 0;
  int following_count = 0;
  // for profile picture
  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
    apiUpload();
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
    apiUpload();
  }

    apiUpload()async{
    setState(() {
      isloading=true;
    });
    if(_image==null){
      Utils.fireToast("there is no data in this image file");
    }
      var vaue= await FileService.uploadPostImage(_image);
       getapi(vaue);

    }
  void getapi(String vaue)async {
    setState(() {
      isloading=false;
    });
    Users user=await DataService.loadUser();
    user.img_url=vaue;
    await  DataService.updateUser(user);
    _apiLoader();
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Pick Photo'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Take Photo'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  void _apiLoader(){
   DataService.loadUser().then((value) => {
     showUser(value)
   });

  }
  showUser(Users value) {
    setState(() {
      this.fullname=value.fullname;
      this.email=value.email;
      this.photo_url=value.img_url;
      this.followers_count=value.followers_count;
      this.following_count=value.following_count;
    });
  }


  List<Post> items=new List();
  // ignore: must_call_super
  initState(){
    super.initState();
    resyApi();
    _apiLoader();
  }
                                 //  for my posts
  Future resyApi()async{
    setState(() {
      isloading=true;
    });
  List<Post> posts=await DataService.loading();
    update(posts);
  }
   void update(List<Post> posts) {
    setState(() {
      items=posts;
      counter=items.length;
    });
    setState(() {
      isloading=false;
    });
   }
  action()async{
   var result= await Utils.dialogCommon(context, "Profile", "do you want to log out ?", false);
   if(result!=null&&result){
     AuthService.signOutUser(context);
   }

  }
  void actionREmove(Post item) async {
    var result= await Utils.dialogCommon(context, "Profile", "do you want to delete this post ?", false);
    if(result!=null&&result){
      await  DataService.removePost(item);
      resyApi();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Profile",style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: "Billabong"
        ),),elevation: 0,centerTitle: true,
        actions: [
          IconButton(icon:Icon(Icons.exit_to_app,color: Colors.red,), onPressed:(){
            action();
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
                          _showPicker(context);
                        },)


                      ],),
                  ),
                )
              ],),
              SizedBox(height: 10,),
              Text(fullname.toUpperCase(),style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.bold),),
              SizedBox(height: 3,),
              Text(email,style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.normal),),
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
      onLongPress: (){
        actionREmove(item);
      },
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
                  imageUrl:item.img_post,
                  placeholder: (_,url)=>CircularProgressIndicator(),
                  errorWidget:(_,url,error)=>Icon(Icons.error),
                ), ),
                SizedBox(height: 3,),
                Text(item.caption),

              ],
            ),
          ),

        ],
      ),
    );
  }






}
