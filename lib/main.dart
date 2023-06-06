import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newcapstone/firebase_options.dart';
import 'package:newcapstone/src/googleMap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:newcapstone/src/home_page.dart';
import 'package:newcapstone/src/login_page.dart';

import 'community/home_cubit.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final status = await Geolocator.checkPermission();
  if (status == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

Widget platformChoice() {
  if(kIsWeb) {
    return googleMapPage();
  } else {
    return BlocProvider(
        create: (_) => HomeCubit(), child: googleMapPage());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      routes: {
        '/': (context) {
          return platformChoice();
        }
      });
  }
}
