
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagramclone/Controller/prefs.dart';
import 'package:instagramclone/Model/Post_Model.dart';
import 'package:instagramclone/Model/UserName.dart';

import 'flutter_toast.dart';

class DataService{
  static final _fireStore=Firestore.instance;


  static String folder_user="users";
  static String folder_posts="posts";
  static String folder_feeds="feeds";
  static String folder_following = "following";
  static String folder_followers = "followers";




  static Future storeUser(Users user)async{
    user.uid=await Prefs.loadUserId();
    Map<String,String> params=await Utils.deviceParams();
    user.device_id=params["device_id"];
    user.device_type=params["device_type"];
    user.device_token=params["device_token"];
    return _fireStore.collection(folder_user).document(user.uid).setData(user.toJson());
  }

  static Future <Users> loadUser() async{
    String uid=await Prefs.loadUserId();
    var value=await _fireStore.collection(folder_user).document(uid).get();
    Users user=Users.fromJson(value.data);
    var querySnapshot1 = await _fireStore.collection(folder_user).document(uid).collection(folder_followers).getDocuments();
    user.followers_count = querySnapshot1.documents.length;

    var querySnapshot2 = await _fireStore.collection(folder_user).document(uid).collection(folder_following).getDocuments();
    user.following_count = querySnapshot2.documents.length;
    return user;
  }

  static Future updateUser(Users user)async{
    String uid=await Prefs.loadUserId();
    return  _fireStore.collection(folder_user).document(uid).updateData(user.toJson());

  }

  static Future<List<Users>> searchUser(String keyword)async{
    List<Users> items=List();

    var querySnapshot = await _fireStore.collection(folder_user).orderBy("email").startAt([keyword]).getDocuments();
    print(querySnapshot.documents.length);
    String uid=await Prefs.loadUserId();
    querySnapshot.documents.forEach((result) {
      Users newUser = Users.fromJson(result.data);
      if (newUser.uid != uid) {
        items.add(newUser);
      }

    });
    return items;
  }

  // for  uploadPosts to firebase database
  static Future<Post> storePost(Post post)async{
    Users me=await loadUser();
    post.uid=me.uid;
    post.fullname=me.fullname;
    post.img_user=me.img_url;
    post.date=Prefs.currentDate();

    String postId=_fireStore.collection(folder_user).document(me.uid).collection(folder_posts).document().documentID;
    post.id=postId;
    await _fireStore.collection(folder_user).document(me.uid).collection(folder_posts).document(postId).setData(post.toJson());
    return post;
  }

  static Future<Post> storeFeed(Post post)async{
    String uid=await Prefs.loadUserId();
    await _fireStore.collection(folder_user).document(uid).collection(folder_feeds).document(post.id).setData(post.toJson());
    return post;
  }


  static Future<List<Post>> loadUsers()async{
    List<Post> postv=new List();
    String uid=await Prefs.loadUserId();
    var snapshots=await _fireStore.collection(folder_user).document(uid).collection(folder_feeds).getDocuments();
        snapshots.documents.forEach((element) { 
          Post posts=Post.fromJson(element.data);
          if(posts.uid==uid) posts.mine=true;
          postv.add(posts);
        });
        return postv;
  }




  static Future<List<Post>> loading()async{
    List<Post> postv=new List();
    String uid=await Prefs.loadUserId();
    var snapshots=await _fireStore.collection(folder_user).document(uid).collection(folder_posts).getDocuments();
    snapshots.documents.forEach((element) {
      Post posts=Post.fromJson(element.data);
      postv.add(posts);
    });
    return postv;
  }
  static Future<Post> likePost(Post post, bool liked) async {
    String uid = await Prefs.loadUserId();
    post.liked = liked;

    await _fireStore.collection(folder_user).document(uid).collection(folder_feeds).document(post.id).setData(post.toJson());

    if(uid == post.uid){
      await _fireStore.collection(folder_user).document(uid).collection(folder_posts).document(post.id).setData(post.toJson());
    }
    return post;
  }
  static Future<List<Post>> loadLikes() async {
    String uid = await Prefs.loadUserId();
    List<Post> posts = new List();

    var querySnapshot = await _fireStore.collection(folder_user).document(uid).collection(folder_feeds).where("liked", isEqualTo: true).getDocuments();

    querySnapshot.documents.forEach((result) {
      Post post = Post.fromJson(result.data);
      if(post.uid == uid) post.mine = true;
      posts.add(post);
    });
    return posts;

  }
  // Follower and Following Related

  static Future<Users> followUser(Users someone) async {
    Users me = await loadUser();

    // I followed to someone
    await _fireStore.collection(folder_user).document(me.uid).collection(folder_following).document(someone.uid).setData(someone.toJson());

    // I am in someone`s followers
    await _fireStore.collection(folder_user).document(someone.uid).collection(folder_followers).document(me.uid).setData(me.toJson());

    return someone;
  }

  static Future<Users> unfollowUser(Users someone) async {
    Users me = await loadUser();

    // I un followed to someone
    await _fireStore.collection(folder_user).document(me.uid).collection(folder_following).document(someone.uid).delete();

    // I am not in someone`s followers
    await _fireStore.collection(folder_user).document(someone.uid).collection(folder_followers).document(me.uid).delete();

    return someone;
  }

  static Future storePostsToMyFeed(Users someone) async{
    // Store someone`s posts to my feed

    List<Post> posts = new List();
    var querySnapshot = await _fireStore.collection(folder_user).document(someone.uid).collection(folder_posts).getDocuments();
    querySnapshot.documents.forEach((result) {
      var post = Post.fromJson(result.data);
      post.liked = false;
      posts.add(post);
    });

    for(Post post in posts){
      storeFeed(post);
    }
  }

  static Future removePostsFromMyFeed(Users someone) async{
    // Remove someone`s posts from my feed

    List<Post> posts = new List();
    var querySnapshot = await _fireStore.collection(folder_user).document(someone.uid).collection(folder_posts).getDocuments();
    querySnapshot.documents.forEach((result) {
      posts.add(Post.fromJson(result.data));
    });

    for(Post post in posts){
      removeFeed(post);
    }
  }

  static Future removeFeed(Post post) async{
    String uid = await Prefs.loadUserId();

    return await _fireStore.collection(folder_user).document(uid).collection(folder_feeds).document(post.id).delete();
  }

  static Future removePost(Post post) async{
    String uid = await Prefs.loadUserId();
    await removeFeed(post);
    return await _fireStore.collection(folder_user).document(uid)
        .collection(folder_posts).document(post.id).delete();
  }

  static Future <List<Users>> loadUserOthers() async{
    String uid=await Prefs.loadUserId();
    List<Users> items=List();
    var value=await _fireStore.collection(folder_user).getDocuments();
    value.documents.forEach((element) {
      Users user=Users.fromJson(element.data);
      if(uid!=user.uid){
        items.add(user);
      }else{
        return null;
      }

    });
    return items;
  }
  static Future<List<Post>> loadingPost(Users someone)async{
    List<Post> postv=new List();
    var snapshots=await _fireStore.collection(folder_user).document(someone.uid).collection(folder_posts).getDocuments();
    snapshots.documents.forEach((element) {
      Post posts=Post.fromJson(element.data);
      postv.add(posts);
    });
    return postv;
  }

  // var querySnapshot1 = await _fireStore.collection(folder_user).document(uid).collection(folder_followers).getDocuments();
  // user.followers_count = querySnapshot1.documents.length;
  //
  // var querySnapshot2 = await _fireStore.collection(folder_user).document(uid).collection(folder_following).getDocuments();
  // user.following_count = querySnapshot2.documents.length;

}