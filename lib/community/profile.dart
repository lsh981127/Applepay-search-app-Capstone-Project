import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var userName = "";
  var userUid = "";
  var userEmail = "";
  var userPhoto = "";

  Future<void> bringData() async {
    var snapshot = FirebaseFirestore.instance
        .collection("users")
        .doc("${FirebaseAuth.instance.currentUser?.uid}")
        .get();

    var data = await snapshot;

    var name = (data.data()?["name"].toString() ?? "");
    var uid = (data.data()?["uid"].toString() ?? "");
    var email = (data.data()?["userEmail"].toString() ?? "");
    var photo = (data.data()?["imageUrl"].toString() ?? "");

    setState(() {
      userName = name;
      userUid = uid;
      userEmail = email;
      userPhoto = photo;
    });
  }

  @override
  void initState() {
    super.initState();
    bringData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text(
          '내 정보',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                    context, MaterialPageRoute(builder: (context) => platformChoice()));
              },
              color: Color(0xff252532),
            ),
          ]),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 100,
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      WidgetSpan(
                                        child: Icon(
                                          Icons.person_rounded,
                                          color: Colors.black,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(width: 5.0), // Optional spacing between icon and text
                                      ),
                                      TextSpan(
                                        text: "이름: ${userName}",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "이메일: ${userEmail}",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13.0,
                                  ),
                                ),
                              ]),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      height: 160,
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey.shade300, width: 1),
                      ),
                      child:  Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('커뮤니티',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                  child: Text('닉네임 설정',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15.0)),
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero)),
                              TextButton(
                                  child: Text('내 게시글 보기',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15.0)),
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero)),
                            ]),
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 160,
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('기타',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              child: Text('사업자등록 증명',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0)),
                              onPressed: () {},
                              style:
                                  TextButton.styleFrom(padding: EdgeInsets.zero)),
                          TextButton(
                              child: Text('로그아웃  ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0)),
                              onPressed: () {
                                Navigator.pushNamed(context, '/');
                              },
                              style:
                                  TextButton.styleFrom(padding: EdgeInsets.zero)),
                        ]),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
