import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:instagramclone/Controller/FireBase_Storage.dart';
import 'package:instagramclone/Controller/flutter_toast.dart';
import 'package:instagramclone/Model/Post_Model.dart';

class MyLikePage extends StatefulWidget {
  @override
  _MyLikePageState createState() => _MyLikePageState();
}

class _MyLikePageState extends State<MyLikePage> {
  List<Post> items=new List();
  bool isLoading =false;
  void _apiPostUnLike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DataService.likePost(post, false);
    apiPostLIkes();

  }
  
   Future <void> apiPostLIkes()async{
     setState(() {
       isLoading=true;
     });
   List<Post> posts= await DataService.loadLikes();
    give(posts);
  }
  void give(List<Post> posts) {
     setState(() {
       items=posts;
       isLoading=false;
     });
  }

  void actionREmove(Post item) async {
    var result= await Utils.dialogCommon(context, "Profile", "do you want to delete this post ?", false);
    if(result!=null&&result){
      await  DataService.removePost(item);
      apiPostLIkes();
    }
  }




  // ignore: must_call_super
  initState(){
    super.initState();
    apiPostLIkes();
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

        ),
        backgroundColor: Colors.white,
        body:Stack(children: [
          items.length>0?
          ListView.builder(itemCount:items.length,itemBuilder:(_,i){
            print(items[i].img_user);

          return makeOfitme(items[i]);
          }):Center(child: Text("there is no data"),),isLoading
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
                item.img_user!=null ?ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.asset("asset/instagramPicture.png",
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,)
                ):ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(item.img_user,
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
              ],),
              item.mine?IconButton(icon:Icon(SimpleLineIcons.options), onPressed: (){
                actionREmove( item);
              }):SizedBox.shrink()
            ],),
        ),
        // images
        // Image.network(item.postImage,fit: BoxFit.cover,),
        CachedNetworkImage(
          imageUrl:item.img_post,
          placeholder: (_,url)=>CircularProgressIndicator(),
          errorWidget:(_,url,error)=>Icon(Icons.error),
        ),

        // icon buttons
        Row(
          children: [
            IconButton(icon:Icon(FontAwesome.heart,color: Colors.red,), onPressed: (){
           if (item.liked) {
             _apiPostUnLike(item);
            }}),
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


  }

