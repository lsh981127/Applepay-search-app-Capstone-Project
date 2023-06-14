import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../community/Post.dart';
import '../community/color.dart';
import '../community/freeforum_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class myPostsPage extends StatefulWidget{
  @override
  _myPostsPageState createState()=>_myPostsPageState();
}

class _myPostsPageState extends State<myPostsPage> {
  List<Post> postSet = [];


  @override
  void initState() {
    super.initState();
    getUsername();
  }

  var userName = "";
  Future<void> getUsername() async {
    final userCollectionReference = FirebaseFirestore.instance
        .collection("users")
        .doc('${FirebaseAuth.instance.currentUser?.uid}')
        .get();

    final data = await userCollectionReference;
    final name = (data.data()?["nickname"].toString() ?? "");

    setState(() {
      userName = name;
    });
  }

  Future<void> bringData() async {
    late String _title, _content, _writer, _date, _time;
    late int _like,_comment;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where("writer",isEqualTo:userName)
        .get();

    for (var doc in querySnapshot.docs) {
      _title = doc["title"];
      _content = doc["content"];
      _writer = doc["writer"];
      _date = doc["date"];
      _time = doc["time"];
      _like = doc["like"];
      _comment = doc["comment"];
      print(_content);
      postSet.add(Post(_title, _content, _writer, _date, _time,_like,_comment));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,//색변경
        ),
        title: const Text(
          '내 정보',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
      ),
      body: FutureBuilder<void>(
        future: bringData(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: postSet.length,
            itemBuilder: (BuildContext context, int index) {
              return contextBox(context, postSet[index]);
            },
          );
        },
      ),
    );
  }
}

Widget contextBox(BuildContext context, Post post) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => freeForumDetail(context, post)
          )
      );
    },
    child: Expanded(
      child: Container(
          color: Colors.white,
          width: 420,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18.0),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  width: 380,
                  child: Text(
                    post.contents,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15.0, color: Colors.blueGrey),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            post.date,
                            style: TextStyle(
                                fontSize: 13.0, color: Colors.blueGrey),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            post.writer,
                            style: TextStyle(
                                fontSize: 13.0, color: Colors.blueGrey),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.hand_thumbsup,
                            color: Palette.everyRed,
                            size: 14,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${post.like}",
                            style: TextStyle(
                                color: Palette.everyRed, fontSize: 14.0),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Icon(
                            CupertinoIcons.chat_bubble,
                            color: Colors.blueAccent,
                            size: 14,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${post.comment}",
                            style: TextStyle(
                                color: Colors.blueAccent, fontSize: 14.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 1500,
                  height: 0.4,
                  color: Colors.grey,
                )
              ],
            ),
          )),
    ),
  );
}