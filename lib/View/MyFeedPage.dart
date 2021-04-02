
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:instagramclone/Model/Post_Model.dart';
class MyFeedPage extends StatefulWidget {
  PageController pageConroller;
  MyFeedPage({this.pageConroller});


  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {

  List<Post> items=new List();
  // ignore: must_call_super
  String post_img="https://firebasestorage.googleapis.com/v0/b/koreanguideway.appspot.com/o/develop%2Fpost.png?alt=media&token=f0b1ba56-4bf4-4df2-9f43-6b8665cdc964";
  String post_img2="https://firebasestorage.googleapis.com/v0/b/koreanguideway.appspot.com/o/develop%2Fpost2.png?alt=media&token=ac0c131a-4e9e-40c0-a75a-88e586b28b72";
  initState(){
    super.initState();
    items.add(Post(postCaption:"i took a picture one of my friend yesterday who work in amazon as software engineer ",postImage:post_img  ));
    items.add(Post(postCaption:"i took a picture one of my friend yesterday who work in amazon as software engineer ",postImage: post_img2 ));
  }





  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Instagram",style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: "Billabong"
        ),),centerTitle: true,
        actions: [
          IconButton(icon:Icon(Icons.camera_alt,color: Colors.black,), onPressed: (){
            widget.pageConroller.animateToPage(2, duration:Duration(milliseconds: 200), curve:Curves.easeIn);
          })
        ],
      ),
      backgroundColor: Colors.white,
      body:ListView.builder(itemCount:items.length,itemBuilder:(_,i){

        return makeOfitme(items[i]);
      })
    );
  }

  Widget makeOfitme(Post item) {
    return Container(
      color: Colors.white,child: Column(
      children: [
        Divider(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image(
                image: AssetImage("asset/instagramPicture.png"),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Username",style: TextStyle(
                    fontWeight: FontWeight.bold,color: Colors.black
                ),),
                Text("Febaury 2, 2021",style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),)


              ],)
          ],),
            IconButton(icon:Icon(SimpleLineIcons.options), onPressed: (){})
          ],),
        ),
        // images
        // Image.network(item.postImage,fit: BoxFit.cover,),
        CachedNetworkImage(
            imageUrl:item.postImage,
          placeholder: (_,url)=>CircularProgressIndicator(),
          errorWidget:(_,url,error)=>Icon(Icons.error),
        ),

        // icon buttons
        Row(
          children: [
            IconButton(icon:Icon(FontAwesome.heart_o), onPressed: (){}),
            IconButton(icon:Icon(FontAwesome.send), onPressed: (){})

          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: RichText(
            softWrap: true,
            overflow: TextOverflow.visible,
            text: TextSpan(
              children: [
                TextSpan(
                  text: " ${item.postCaption}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    ),);
  }
}
