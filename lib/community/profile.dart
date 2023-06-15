import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newcapstone/mypage/nickname_change.dart';
import '../mypage/business_register.dart';
import '../mypage/myposts.dart';

import '../main.dart';
import '../src/googleMap.dart';

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
  var userNickName = "";

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
    var nickname = (data.data()?["nickname"].toString() ?? "");

    setState(() {
      userName = name;
      userUid = uid;
      userEmail = email;
      userPhoto = photo;
      userNickName = nickname;
    });
  }

  logoutAccount() async {
    // 로그아웃 함수
    await GoogleSignIn().signOut(); // 계정 선택
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const googleMapPage()),
        (Route<dynamic> route) => false);
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
        iconTheme: IconThemeData(
          color: Colors.black, //색변경
        ),
        title: const Text(
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => platformChoice()));
              },
              color: const Color(0xff252532),
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
                    height: 150,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(20),
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
                                      const WidgetSpan(
                                        child: Icon(
                                          Icons.person_rounded,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const WidgetSpan(
                                        child: SizedBox(
                                            width:
                                                5.0), // Optional spacing between icon and text
                                      ),
                                      TextSpan(
                                        text: "이름: ${userName}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    "닉네임: ${userNickName}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    "이메일: ${userEmail}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                )
                              ]),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 180,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('커뮤니티',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              child: const Text('닉네임 설정',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => NickNameChangePage()));
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero)),
                          TextButton(
                              child: const Text('내 게시글 보기',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => myPostsPage()));
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero)),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    height: 180,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('기타',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              child: const Text('사업자등록 증명',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0)),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BusinessPage()));
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero)),
                          TextButton(
                              child: const Text('로그아웃  ',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15.0)),
                              onPressed: () async {
                                if (!context.mounted) {
                                  return;
                                }
                                await logoutAccount();
                              },
                              style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero)),
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
