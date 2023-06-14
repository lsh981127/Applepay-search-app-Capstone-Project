import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'Comment.dart';
import 'Post.dart';
import 'color.dart';
import 'package:intl/intl.dart';

class freeForumDetail extends StatefulWidget {
  BuildContext context;
  final Post post;

  freeForumDetail(this.context, this.post);

  @override
  State<freeForumDetail> createState() => _freeForumDetailState();
}

class _freeForumDetailState extends State<freeForumDetail> {
  final _controllerB = TextEditingController();
  bool anonymous = true;
  bool bell = false;

  var postTitle = "";
  var postContent = "";
  var postDate = "";
  var postTime = "";
  var postWriter = "";
  var postLike = 0;
  var postComment = 0;
  var commentNum = 0;

  var userName = "";

  List<Comment> commentSet = [];

  void updateLike(like) async {
    final postCollectionReference =
        FirebaseFirestore.instance.collection("posts").doc(postTitle);
    postCollectionReference.update({"like": like});
  }

  void updateComment(comment,cnt) async {
    DateTime dt = DateTime.now();
    final date = DateFormat('MM/dd').format(dt);
    final time = DateFormat('HH:mm').format(dt);

    final commentCollectionReference = FirebaseFirestore.instance
        .collection('posts')
        .doc(postTitle)
        .collection('comments')
        .doc(comment);

    commentCollectionReference.set({
      "commentor": userName,
      "content": comment,
      "date": date,
      "time": time,
    });

    final postCollectionReference =
        FirebaseFirestore.instance.collection("posts").doc(postTitle);

    postCollectionReference.update({"comment": cnt});

  }

  Future<void> getPost() async {
    final postCollectionReference = FirebaseFirestore.instance
        .collection("posts")
        .doc(widget.post.title)
        .get();

    final data = await postCollectionReference;

    final title = (data.data()?["title"].toString() ?? "");
    final content = (data.data()?["content"].toString() ?? "");
    final date = (data.data()?["date"].toString() ?? "");
    final time = (data.data()?["time"].toString() ?? "");
    final name = (data.data()?["writer"].toString() ?? "");
    final like = (data.data()?["like"] ?? 0);
    final comment = (data.data()?["comment"] ?? 0);

    setState(() {
      postTitle = title;
      postContent = content;
      postDate = date;
      postTime = time;
      postWriter = name;
      postLike = like;
      postComment = comment;
    });
  }

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

  Future<void> getComment() async {
    late String _content, _writer, _date, _time;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postTitle)
        .collection('comments')
        .get();
    commentSet=[];
    for (var doc in querySnapshot.docs) {
      _writer = doc['commentor'];
      _content = doc['content'];
      _date = doc['date'];
      _time = doc['time'];
      print(_content);
      commentSet.add(Comment(_content, _writer, _date, _time));
    }
    print('---------------------------');
    // setState(() {
    //   commentNum = querySnapshot.docs.length;
    // });
  }

  // Widget getComment() {
  //   late String _content, _writer, _date, _time;
  //
  //   return StreamBuilder<QuerySnapshot>(
  //       stream: FirebaseFirestore.instance
  //           .collection('posts')
  //           .doc(postTitle)
  //           .collection('comments')
  //           .snapshots(),
  //       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //         if (snapshot.data == null) {
  //           return const Center(
  //             child: Text(""),
  //           );
  //         } else {
  //           commentSet = [];
  //           for (var doc in snapshot.data!.docs) {
  //             _writer = doc['commentor'];
  //             _content = doc['content'];
  //             _date = doc['date'];
  //             _time = doc['time'];
  //             print(_content);
  //             commentSet.add(Comment(_content, _writer, _date, _time));
  //           }
  //           print("-------------------------------------------");
  //
  //           return Column(children: [
  //             Expanded(
  //               // child: SizedBox(
  //               //   child: ListView.builder(
  //               //   itemCount: commentSet.length,
  //               //   itemBuilder: (BuildContext context, int index) {
  //               //     return commentBox(context, commentSet[index]);
  //               // },
  //               child: SizedBox(
  //                 height: 30,
  //                 child: ListView.builder(
  //                   itemCount: commentSet.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     return commentBox(context, commentSet[index]);
  //                   },
  //                 ),
  //               ),
  //             )
  //           ]);
  //         }
  //       });
  // }

  @override
  void dispose() {
    _controllerB.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPost();
    getUsername();
  }

  @override
  Widget build(BuildContext context) {
    int likeNum = postLike;
    int commentNum = postComment;
    double keyboard = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
          children: const [
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
        backgroundColor: Colors.white70,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon: Stack(children: [
            CupertinoNavigationBarBackButton(
              onPressed: () {
                Navigator.pop(context);
              },
              color: const Color(0xff252532),
            ),
          ]),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Container(
                  color: Colors.white,
                  width: 1500,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 15, right: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      image: const DecorationImage(
                                          image: AssetImage("profile.png"),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(postWriter,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(postDate + " " + postTime,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13.0,
                                              )),
                                        ],
                                      )
                                    ]),
                              ]),
                            ]),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            postTitle,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            postContent,
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.black),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.only(right:10),
                                        child: Row(
                                          children:[
                                            GestureDetector(
                                              child: likeWidget(
                                                  CupertinoIcons.hand_thumbsup, "공감"),
                                              onTap: () {
                                                setState(() {
                                                  postLike++;
                                                  updateLike(postLike);
                                                });
                                              },
                                            ),
                                            Text(
                                              "${likeNum}",
                                              style: const TextStyle(
                                                  color: Palette.everyRed,
                                                  fontSize: 14.0),
                                            ),
                                          ]
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      const Icon(
                                        CupertinoIcons.chat_bubble,
                                        color: Colors.blueAccent,
                                        size: 14,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "${commentNum}",
                                        style: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 14.0),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              // const Icon(
                              //   CupertinoIcons.hand_thumbsup,
                              //   color: Palette.everyRed,
                              //   size: 14,
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          SizedBox(
            height: 300,
            // child: getComment(),
            child: FutureBuilder<void>(
                future: getComment(),
                builder: (context, snapshot) {
                  return SizedBox(
                    height: 30,
                    child: ListView.builder(
                      itemCount: commentSet.length,
                      itemBuilder: (BuildContext context, int index) {
                        return commentBox(context, commentSet[index]);
                      },
                    ),
                  );
                }),
            // child: FutureBuilder<void>(
            //     future: getCommentNum(),
            //     builder: (context, snapshot) {
            //       return SizedBox(
            //         height: 30,
            //         child: getComment(),
            //       );
            //     }),
          )
        ],
      )),
      bottomSheet: Padding(
        padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: TextField(
            controller: _controllerB,
            cursorColor: Colors.grey,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(CupertinoIcons.paperplane,
                      color: Palette.everyRed),
                  onPressed: () {
                    setState(() {
                      postComment++;
                      final String comment = _controllerB.text;
                      updateComment(comment,postComment);
                      _controllerB.clear();
                    });
                  },
                  iconSize: 24.0,
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide:
                        BorderSide(color: Colors.grey.shade200, width: 2)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderSide:
                        BorderSide(color: Colors.grey.shade200, width: 2)),
                contentPadding: const EdgeInsets.fromLTRB(30, 10, 10, 0),
                hintText: "댓글을 입력하세요."),
          ),
        ),
      ),
    );
  }

  Widget likeWidget(IconData icon, String title) {
    return Container(
        height: 30,
        width: 50,
        // decoration: BoxDecoration(
        //   color: Colors.grey.shade100,
        //   borderRadius: BorderRadius.circular(10.0),
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: Palette.everyRed,
            ),
            const SizedBox(width: 3),
            Text(title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Palette.everyRed,
                  fontWeight: FontWeight.bold,
                ))
          ],
        ));
  }

  Widget commentBox(BuildContext context, Comment comment) {
    return Padding(
        padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey.shade200, width: 1),
                  ),
                  child: Column(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 13, top: 6, right: 4),
                            child: Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                image: const DecorationImage(
                                    image: AssetImage("profile.png"),
                                    fit: BoxFit.fill),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              comment.writer,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ]),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            "${comment.date}  ${comment.time}",
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15, top: 8, right: 15, bottom: 8),
                        child: Text(
                          comment.contents,
                          style: const TextStyle(
                              fontSize: 15.0, color: Colors.black54),
                        ),
                      ),
                      const SizedBox(height: 13),
                    ]),
                    // Container(
                    //   width: 1500,
                    //   height: 0.4,
                    //   color: Colors.black,
                    // ),
                    const SizedBox(height: 3),
                  ]))
            ]));
  }
}
