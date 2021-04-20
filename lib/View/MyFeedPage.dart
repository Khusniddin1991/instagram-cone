
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:instagramclone/Controller/FireBase_Storage.dart';
import 'package:instagramclone/Controller/flutter_toast.dart';
import 'package:instagramclone/Model/Post_Model.dart';
import 'package:share/share.dart';
class MyFeedPage extends StatefulWidget {
  PageController pageConroller;
  MyFeedPage({this.pageConroller});


  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  bool isLoading=false;

  List<Post> items=new List();
  getdata()async{
  List<Post> posts=  await DataService.loadUsers();
    updat(posts);
  }
  void updat(List<Post> posts) {
    setState(() {
      items=posts;
    });
  }
  // ignore: must_call_super
  initState(){
    super.initState();
    getdata();
  }
  void _apiPostLike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DataService.likePost(post, true);
    setState(() {
      isLoading = false;
      post.liked = true;
    });
  }

  void _apiPostUnLike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DataService.likePost(post, false);
    setState(() {
      isLoading = false;
      post.liked = false;
    });
  }

  void actionREmove(Post item) async {
    var result= await Utils.dialogCommon(context, "Profile", "do you want to delete this post ?", false);
    if(result!=null&&result){
      await  DataService.removePost(item);
      getdata();
    }
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
      body:Stack(children: [
        ListView.builder(itemCount:items.length,itemBuilder:(_,i){

          return makeOfitme(items[i]);
        }),isLoading
            ? Center(
          child: CircularProgressIndicator(),
        )
            : SizedBox.shrink(),
      ],)
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
            item.img_user==null||item.img_user.isEmpty?ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image(
                image: AssetImage("asset/instagramPicture.png"),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ): ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(item.img_user,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,)
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.fullname,style: TextStyle(
                    fontWeight: FontWeight.bold,color: Colors.black
                ),),
                Text(item.date,style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),)


              ],)
          ],),item.mine?
            IconButton(icon:Icon(SimpleLineIcons.options), onPressed: (){
                  actionREmove(item);
            }):SizedBox.shrink()
          ],),
        ),
        // images
        // Image.network(item.postImage,fit: BoxFit.cover,),
        CachedNetworkImage(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
             fit: BoxFit.cover,
            imageUrl:item.img_post,
          placeholder: (_,url)=>Center(child: CircularProgressIndicator()),
          errorWidget:(_,url,error)=>Icon(Icons.error),

        ),

        // icon buttons
        Row(
          children: [
            IconButton(icon:item.liked?Icon(FontAwesome.heart,color: Colors.red,):Icon(FontAwesome.heart_o),onPressed: (){
              if (!item.liked) {
                _apiPostLike(item);
              } else {
                _apiPostUnLike(item);
              }
            }),
            IconButton(icon:Icon(FontAwesome.send), onPressed: (){
              shareButton(link: item.img_post,title: item.caption);
            })

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
                  text: " ${item.caption}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ),
      ],
    ),);
  }

  Future shareButton({dynamic link,String title})async{
    await FlutterShare.share(
      title: "send to another platform",
      text: title,
      linkUrl:link,
      chooserTitle: "Where you wanna share"
    );
  }



}
