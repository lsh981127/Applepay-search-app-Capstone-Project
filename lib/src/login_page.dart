import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newcapstone/src/googleMap.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: ["email", "profile"]).signIn();
    final GoogleSignInAuthentication? googleAuth = await googleUser
        ?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential googleUserCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    // print(googleUserCredential.additionalUserInfo?.profile);
    // print(googleUserCredential.user?.email);

    DocumentSnapshot loginCheckDoc = await FirebaseFirestore.instance
        .collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();

    if (!loginCheckDoc.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(
        {
          'timeRegistry': FieldValue.serverTimestamp(),
          'timeUpdate': FieldValue.serverTimestamp(),
          'isStreaming': false,
          'userEmail': googleUserCredential.user?.email,
        },
        SetOptions(merge: true),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              if(!context.mounted) {
                return ;
              }
              // showAlertDialog();
              await signInWithGoogle();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              const googleMapPage()), (Route<dynamic> route) => false);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                elevation: 0.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(50)
                  ),
                ),
                side: const BorderSide(
                  color: Colors.white,
                )
            ),
            child: Container(
              height: 55,
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children:  [
                  // Container(
                  //   width: 22,
                  //   height: 22,
                  //   child: const Image(
                  //     image: AssetImage('assets/image/intro/google_icon.png'),
                  //     fit: BoxFit.fill,
                  //   ),
                  // ),
                  Text('구글 로그인',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        height: 1.5
                    ),
                  ),
                  SizedBox(width: 10,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
