import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagramclone/Controller/FireBase_Storage.dart';
import 'package:instagramclone/Model/Post_Model.dart';
import 'package:instagramclone/Model/UserName.dart';
import 'package:instagramclone/Model/fullname.dart';


class MySearchPage extends StatefulWidget {
  @override
  _MySearchPageState createState() => _MySearchPageState();
}

class _MySearchPageState extends State<MySearchPage> {
  List<Users> items=List();

  void  searchPage(String keyword)async{
   List <Users> user= await DataService.searchUser(keyword);
       restapi(user);

  }
  void restapi(List<Users> users) {
    setState(() {
      items=users;
    });
  }



  initState(){
    super.initState();
    searchPage("");

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
      body:Container(
        padding: EdgeInsets.only(left: 20,right: 20)
        ,child: Column(
        children: [
          // search
          Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.only(left: 10,right: 10),
           decoration: BoxDecoration(
             color: Colors.grey.withOpacity(0.2),
             borderRadius: BorderRadius.circular(7)

           ),

            height: 45,
            child: TextField(
              controller: searchController,
              style: TextStyle(color: Colors.black87),
              onChanged: (input){
                print(input);
              },
              decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 15,color: Colors.grey),
                icon: Icon(Icons.search,color: Colors.grey,)
              ),
            ),
          ),
          Expanded(child: ListView.builder(itemCount: items.length,itemBuilder:(_,i){
            return makeOfItem(items[i]);
          }),),

      ],),
      )
    );
  }

  Widget makeOfItem(Users item) {
    return Container(
      height: 90,
      child: Row(
        children: [
        Container(
          padding:EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70),
            border: Border.all(width: 1.5,color: Color.fromRGBO(193, 53, 132, 1))

          ),
            child:
        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image(
            image: AssetImage("asset/instagramPicture.png"),
            width: 45,
            height: 45,
            fit: BoxFit.cover,
          ),
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
          Container(
            width: 100,
            height: 30,
            decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(width: 1,color: Color.fromRGBO(193, 53, 132, 1))
            ),
            child: Center(child: Text("Follow"),),
            ),
        ],),)
      ],),
    );
  }


}
