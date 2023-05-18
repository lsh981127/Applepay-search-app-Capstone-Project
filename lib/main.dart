import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:newcapstone/firebase_options.dart';
import 'package:newcapstone/src/googleMap.dart';
import 'package:newcapstone/src/login_page.dart';
import 'package:newcapstone/src/freeforum.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

Widget platformChoice() {
  if(kIsWeb) {
    // return LoginPage();
    return googleMapPage();
  } else {
    if(Platform.isAndroid) {
      // return mapPage();
      return googleMapPage();
    } else {
      return googleMapPage();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: platformChoice(),
    );
  }
}
