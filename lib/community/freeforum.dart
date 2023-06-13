import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:newcapstone/community/write_item.dart';
import '../main.dart';
import 'Post.dart';
import '../community/color.dart';
import 'database.dart';
import 'search.dart';
import 'freeforum_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class freeForum extends StatefulWidget{
  @override
  _freeForumState createState()=>_freeForumState();
}

class _freeForumState extends State<freeForum> {
  List<Post> postSet = [
    dataBase.post1,
    dataBase.post2,
    dataBase.post3,
  ];


  @override
  void initState() {
    super.initState();
  }



  Future<void> bringData() async {
    late String _title, _content, _writer, _date, _time;
    late int _like,_comment;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('posts').get();
    for (var doc in querySnapshot.docs) {
      _title = doc["title"];
      _content = doc["content"];
      _writer = doc["writer"];
      _date = doc["date"];
      _time = doc["time"];
      _like = doc["like"];
      _comment = doc["comment"];
      postSet.add(Post(_title, _content, _writer, _date, _time,_like,_comment));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              '자유게시판',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
            Text(
              "애플페이_캡스톤",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Stack(children: [
            CupertinoNavigationBarBackButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => platformChoice()));
              },
              color: Color(0xff252532),
            ),
          ]),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Search()));
            },
            icon: Icon(CupertinoIcons.search, size: 23),
            color: Colors.black,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) =>
                      CupertinoActionSheet(
                          title: const Text('게시판 메뉴'),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: const Text('글 쓰기'),
                              onPressed: () {
                                Navigator.pop(context, '글 쓰기');
                                Get.to(WritePage());
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: const Text('즐겨찾기에서 삭제'),
                              onPressed: () {
                                Navigator.pop(context, '즐겨찾기에서 삭제');
                              },
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text('취소'),
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.pop(context, '취소');
                            },
                          )),
                );
              },
              icon: Icon(CupertinoIcons.ellipsis_vertical, size: 23),
              color: Colors.black,
            ),
          )
        ],
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