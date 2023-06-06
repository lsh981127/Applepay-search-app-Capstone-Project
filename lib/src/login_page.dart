import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newcapstone/src/googleMap.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  String? name, imageUrl, userEmail, uid;




  Future<User?> signInWithGoogleWeb() async {
    // Initialize Firebase
    await Firebase.initializeApp();
    User? user;
    FirebaseAuth auth = FirebaseAuth.instance;
    // The `GoogleAuthProvider` can only be
    // used while running on the web
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential =
      await auth.signInWithPopup(authProvider);
      user = userCredential.user;
    } catch (e) {
      print(e);
    }

    if (user != null) {
      uid = user.uid;
      name = user.displayName;
      userEmail = user.email;
      imageUrl = user.photoURL;
      //
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setBool('auth', true);
      // print("name: $name");
      // print("userEmail: $userEmail");
      // print("imageUrl: $imageUrl");

      await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set(
            {
              'uid': uid,
              'name': name,
              'userEmail': userEmail,
              'imageUrl': imageUrl,
            },
            SetOptions(merge: true),
          );

    }
    return user;
  }

  Future<void> signInWithGoogleApp() async {    //앱용 로그인 코드
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
  void initState() {
    super.initState();
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
              // await signInWithGoogle();
              kIsWeb ? await signInWithGoogleWeb() : await signInWithGoogleApp();
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
