import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/Controller/FireBase_Storage.dart';
import 'package:instagramclone/Controller/file_data.dart';
import 'package:instagramclone/Controller/http_services.dart';
import 'package:instagramclone/Model/Post_Model.dart';


class MyUploadPage extends StatefulWidget {
  PageController pageConrollers;
  MyUploadPage({@required this.pageConrollers});
  @override
  _MyUploadPageState createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {
   bool isloading=false;
  final captioncontroller=new TextEditingController();
  File _image;


  _uploadNewPost() {
      setState(() {
        isloading=true;
      });
    if (_image == null) return;
    _apiPostImage();
    // movetoFeed();
  }

  _apiPostImage()async {
    String downloadUrl=await FileService.uploadPostImage(_image);
    restApi(downloadUrl);
    

  }
  void restApi(String downloadUrl) {
    String caption = captioncontroller.text.toString().trim();
    if (caption.isEmpty) return;
    Post post=Post(img_post:downloadUrl,caption: caption );
    apiPost(post);
  }
  void apiPost(Post post)async {
  Post posted=  await DataService.storePost(post);
   await DataService.storeFeed(posted);
  movetoFeed();
  }
  movetoFeed(){

    setState(() {
      isloading=false;
    });
    _image=null;
    captioncontroller.text='';
    widget.pageConrollers.animateToPage(0, duration:Duration(milliseconds: 200), curve:Curves.easeIn);

  }

  _imgFromGallery() async {
    File image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
  }
  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = image;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Upload",style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: "Billabong"
        ),),
        elevation: 0,centerTitle: true,actions: [
          IconButton(icon:Icon(Icons.post_add,color:   Color.fromRGBO(252, 175, 69, 1),), onPressed: (){
            _uploadNewPost();
            HttpServices.POST();
          })
      ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      _showPicker(context);
                    },
                    child: Container(
                      color: Colors.grey.withOpacity(0.4),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.width,
                      child:_image==null?Center(child: Icon(Icons.add_a_photo,size: 60,color: Colors.grey,),):
                      Stack(children: [
                        Image.file(_image, height: double.infinity,width: double.infinity,fit: BoxFit.cover,),
                        Container(
                          width: double.infinity,
                          color: Colors.black12,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: (){
                                  setState(() {
                                    _image = null;
                                  });
                                },
                                icon: Icon(Icons.highlight_remove),
                                color: Colors.yellowAccent,
                              ),
                            ],
                          ),
                        ),
                      ],)
                      ,

                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10,right: 10,top: 10),
                    child: TextField(
                      controller: captioncontroller,
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                          hintText: "Caption",
                          hintStyle: TextStyle(fontSize: 17,color: Colors.black38)
                      ),
                    ),

                  )
                ],
              ),
            ),
          ),isloading?Center(child: CircularProgressIndicator(),):Text("")
        ],
      )
    );
  }




}
