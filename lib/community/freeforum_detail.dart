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
  var postContent= "";
  var postDate="";
  var postTime="";
  var postWriter="";
  var postLike=0;
  var postComment=0;

  var userName="";

  // var commentWriter="";
  // var commentContent="";
  List<Comment> commentSet = [];
  // var commentNum=0; //postComment랑 똑같은 값이라 없애도 되지 않을까

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
      postComment= comment;
    });
  }

  Future<void> getUsername() async {
    final userCollectionReference = FirebaseFirestore.instance
        .collection("users")
        .doc('${FirebaseAuth.instance.currentUser?.uid}')
        .get();

    final data = await userCollectionReference;
    final name = (data.data()?["name"].toString() ?? "");

    setState(() {
      userName=name;
    });
  }

  Future<void> getComment() async {
    late String _content, _writer, _date, _time;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('posts').doc(postTitle).collection('comments').get();
    // final commentCount=querySnapshot.docs.length;
    for (var doc in querySnapshot.docs) {
      _writer = doc['commentor'];
      _content =doc['content'];
      _date=doc['date'];
      _time=doc['time'];
      print(_writer);
      print(_content);
      print(_date);
      print(_time);
      commentSet.add(Comment(_content, _writer, _date, _time));
    }
    // setState(() {
    //   commentNum = commentCount;
    // });
  }


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
    getComment();
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
                  Navigator.pop(context);
                },
                color: Color(0xff252532),
              ),
            ]),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  bell == false ? bell = true : bell = false;
                });
              },
              icon: Icon(CupertinoIcons.bell,
                  size: 23, color: bell == false ? Colors.grey : Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                        title: const Text('글 메뉴'),
                        actions: <Widget>[
                          CupertinoActionSheetAction(
                            child: const Text('쪽지 보내기'),
                            onPressed: () {
                              Navigator.pop(context, '쪽지 보내기');
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: const Text('신고'),
                            onPressed: () {
                              Navigator.pop(context, '신고');
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: const Text('URL 공유'),
                            onPressed: () {
                              Navigator.pop(context, 'URL 공유');
                            },
                          )
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
        body: SafeArea(
          child: SingleChildScrollView(
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
                                      image: DecorationImage(
                                          image:
                                          AssetImage("profile.png"),
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
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(postDate + " "+ postTime,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 13.0,
                                              )),
                                        ],
                                      )
                                    ]),
                              ]),
                            ]),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          postTitle,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 21.0),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          postContent,
                          style: TextStyle(fontSize: 16.0, color: Colors.black),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                    "${likeNum}",
                                    style: TextStyle(
                                        color: Palette.everyRed,
                                        fontSize: 14.0),
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
                                    "${commentNum}",
                                    style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontSize: 14.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            GestureDetector(
                              child: likeWidget(
                                  CupertinoIcons.hand_thumbsup, "공감"),
                              onTap: () {
                                setState(() {
                                  postLike++;
                                  final postCollectionReference= FirebaseFirestore.instance.collection("posts").doc(postTitle);
                                  postCollectionReference.update({"like":postLike});
                                });
                              },
                            ),
                            SizedBox(width: 7),
                            GestureDetector(
                              child: likeWidget(CupertinoIcons.star, "스크랩"),
                              onTap: () {
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: 1500,
                          height: 0.4,
                          color: Colors.grey,
                          // child: FutureBuilder<void>(
                          //   future: getComment(),
                          //   builder: (context, snapshot) {
                          //     return ListView.builder(
                          //       itemCount: commentSet.length,
                          //       itemBuilder: (BuildContext context, int index) {
                          //         commentBox(context, 0, commentSet[index]);
                          //       },
                          //     );
                          //   },
                          // ),
                        ),
                        for (int i = 0; i < commentSet.length; i++)
                          commentBox(context, commentSet[i], i),
                      ],
                    ),
                  )
              ),
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.only(
              left: 10.0, right: 10.0, bottom: keyboard > 0 ? 15 : 35),
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
                  prefixIcon: Container(
                      width: 80,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 15.0),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  anonymous == true
                                      ? anonymous = false
                                      : anonymous = true;
                                });
                              },
                              child: anonymous == true
                                  ? Icon(CupertinoIcons.checkmark_square_fill,
                                  color: Palette.everyRed, size: 17)
                                  : Icon(CupertinoIcons.square,
                                  color: Colors.grey, size: 17),
                            ),
                            SizedBox(width: 5.0),
                            Text(
                              "익명",
                              style: TextStyle(
                                  color: anonymous == true
                                      ? Palette.everyRed
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ])),
                  suffixIcon: IconButton(
                    icon: Icon(CupertinoIcons.paperplane,
                        color: Palette.everyRed),
                    onPressed: () {
                      postComment++;
                      final String comment=_controllerB.text;
                      DateTime dt = DateTime.now();
                      final date=DateFormat('MM/dd').format(dt);
                      final time=DateFormat('HH:mm').format(dt);

                      final commentCollectionReference= FirebaseFirestore.instance.collection('posts').doc(postTitle).collection('comments').doc(comment);
                      commentCollectionReference.set({
                        "commentor":userName,
                        "content":comment,
                        "date":date,
                        "time":time,
                      });

                      final postCollectionReference=FirebaseFirestore.instance.collection("posts").doc(postTitle);
                      postCollectionReference.update({"comment":postComment});

                    },
                    iconSize: 24.0,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      borderSide:
                      BorderSide(color: Colors.grey.shade200, width: 2)
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      borderSide:
                      BorderSide(color: Colors.grey.shade200, width: 2)
                  ),
                  contentPadding: EdgeInsets.fromLTRB(30, 10, 10, 0),
                  hintText: "댓글을 입력하세요."
              ),
              onSubmitted: (String value) async {
                await showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog();
                  },
                );
              },
            ),
          ),
        ));
  }
}

Widget likeWidget(IconData icon, String title) {
  return Container(
      height: 30,
      width: 70,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.grey,
          ),
          SizedBox(width: 3),
          Text(title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ))
        ],
      ));
}

Widget commentBox(BuildContext context, Comment comment,int num) {
  int number = num + 1;
  return Padding(
    padding: const EdgeInsets.only(left: 6, top: 10),
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    image: DecorationImage(
                        image: AssetImage("profile.png"),
                        fit: BoxFit.fill),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  comment.writer,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              Row(
                children: [
                  Container(
                      height: 25,
                      width: 110,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 3),
                          Icon(
                            CupertinoIcons.chat_bubble,
                            size: 15,
                            color: Colors.grey,
                          ),
                          VerticalDivider(
                            thickness: 0.4,
                            color: Colors.grey,
                          ),
                          Icon(
                            CupertinoIcons.hand_thumbsup,
                            size: 15,
                            color: Colors.grey,
                          ),
                          VerticalDivider(
                            thickness: 0.4,
                            color: Colors.grey,
                          ),
                          GestureDetector(
                            onTap: () {
                              showCupertinoModalPopup(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoActionSheet(
                                        title: const Text('댓글 메뉴'),
                                        actions: <Widget>[
                                          CupertinoActionSheetAction(
                                            child: const Text('대댓글 알림 켜기'),
                                            onPressed: () {
                                              Navigator.pop(
                                                  context, '대댓글 알림 켜기');
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: const Text('쪽지 보내기'),
                                            onPressed: () {
                                              Navigator.pop(context, '쪽지 보내기');
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: const Text('신고'),
                                            onPressed: () {
                                              Navigator.pop(context, '신고');
                                            },
                                          ),
                                        ],
                                        cancelButton:
                                        CupertinoActionSheetAction(
                                          child: const Text('취소'),
                                          isDefaultAction: true,
                                          onPressed: () {
                                            Navigator.pop(context, '취소');
                                          },
                                        )),
                              );
                            },
                            child: Icon(
                              Icons.more_vert,
                              size: 15,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 3),
                        ],
                      )),
                ],
              ),
            ],
          ),
          Text(
            comment.contents,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
          ),
          SizedBox(height: 4),
          Text(
            comment.date+" "+comment.time,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 1500,
            height: 0.4,
            color: Colors.grey,
          ),
          SizedBox(height: 3),
        ]),
  );
}
