import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Controller/FireBase_Storage.dart';
import 'package:instagramclone/Model/Post_Model.dart';
import 'package:instagramclone/Model/UserName.dart';
import 'package:instagramclone/Model/fullname.dart';

import 'MyProfilePage.dart';
import 'UserProfilePage.dart';


class MySearchPage extends StatefulWidget {
  @override
  _MySearchPageState createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  List<Users> items=List();
  List<Users> item=List();
  List<Post> thigs=List();
  bool isloading=false;

  void _apiLoader()async{
    List<Users> datas=await DataService.loadUserOthers();
    // List<Post> infos=await DataService.loadingPost();
    //     setState(() {
    //       thigs=infos;
    //       item=datas;
    //     });
  }




  void  searchPage(String keyword)async{
   setState(() {
     isloading=true;
   });

   List <Users> user= await DataService.searchUser(keyword);
       restapi(user);

  }
  void restapi(List<Users> users) {
    setState(() {
      items=users;
      isloading=false;
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
    print("go");
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


  initState(){
    super.initState();
    searchPage("");
    _apiLoader();

  }

  Widget build(BuildContext context) {
    var searchController=new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Search",style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontFamily: "Billabong"
        ),),elevation: 0,centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body:Stack(
        children: [
          items.length>0?
          Container(
            padding: EdgeInsets.only(left: 20,right: 20),
            child: Column(
              children: [
                //#searchuser
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  height: 45,
                  child: TextField(
                    style: TextStyle(color: Colors.black87),
                    controller: searchController,
                    onChanged: (input){
                      print(input);
                      searchPage(input);
                    },
                    decoration: InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                      hintStyle: TextStyle(fontSize: 15.0, color: Colors.grey),
                      icon: Icon(Icons.search, color: Colors.grey),
                    ),
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (ctx, index){
                      return makeOfItem(items[index]);
                    },
                  ),
                ),
              ],
            ),
          ):Center(child: Text("there is no data"),),

          isloading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget makeOfItem(Users item) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder:(ctx)=>UserProfilePage(data:item,need:thigs)));
      },
      child: Container(
        height: 90,
        child: Row(
          children: [
          Container(
            padding:EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              border: Border.all(width: 1.5,color: Color.fromRGBO(193, 53, 132, 1))

            ),
              child:item.img_url.isEmpty?ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image(
              image: AssetImage("asset/instagramPicture.png"),
              width: 45,
              height: 45,
              fit: BoxFit.cover,
            ),
          ):ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Image.network(item.img_url,
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,)
              )
          ),
          SizedBox(width: 15,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.fullname,style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 3,),
              Text(item.email,style: TextStyle(color: Colors.black54),)

          ],),
          Expanded(child:Row(
            mainAxisAlignment:MainAxisAlignment.end,
            children: [
            GestureDetector(
             onTap: (){
               if(item.followed){
                 _apiUnfollowUser(item);
               }else{
                 _apiFollowUser(item);
               }
             }
              ,
              child: Container(
                width: 100,
                height: 30,
                decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(width: 1,color: Color.fromRGBO(193, 53, 132, 1))
                ),
                child: Center(
                 child: item.followed ? Text("Following") : Text("Follow"),
      ),
                ),
            ),
          ],),)
        ],),
      ),
    );
  }




}
