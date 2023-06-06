import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gsheets/gsheets.dart';
import 'package:proj4dart/proj4dart.dart';

import '../community/freeforum.dart';
import '../community/home_cubit.dart';
import '../community/profile.dart';


class googleMapPage extends StatefulWidget {
  const googleMapPage({Key? key}) : super(key: key);

  @override
  State<googleMapPage> createState() => _googleMapPageState();
}

class GSheetsAPIConfig {
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "capstonemapapi-382008",
  "private_key_id": "215e01cca1759d3a79de65abe105fed59e650844",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDDZwoJxWI+AjU1\nJfv2SKH+o4gQUViiRrS/2tGihd3JktNgMxLWqAFMQrSZO19QzpRJqeA5y1qn/xKV\nFLD7EJ3O9RlNDYyHyK5gKilzzRZRnbJEnR/0NsH+QU0sLTB2u/Xr8BBd9kx1Gv1b\nUeN1OCwNEHLkT8YUMiIYtmm8v5xBppi4tL+28ZWX5yM/87KZ9utgOKGQ/6wnp/mz\nmzdJhkOL11fRNgCDiFvbZbY0K+yVq8zeRjXJryy012eviMepDUP3jSzOMjrNZoTg\nwiauMHVy7/95kwB9c+88H8FjZLh7tqYGz2f2hR2HAboYBOTHpB672e0OMRE+Ubsg\n2cOkTFepAgMBAAECggEABKaWrWiGb+hjNiUgdppVn2HACCIPhH6UqGj/tVO6ACVf\npOSs+EaeZUoZ0fiA9RjoRvU6nNWIuQKQAX6xFFYEaNvE4uRwKakum/j/lz3UiqkW\nCEkJwikYJpeM9oC1gcCegqOU7XpCaUUfrkU9hIQ2Ptywh1uYtiatUL5Ct6yDKRLQ\neXGDKEwgDOpyCjUQItU98jvfVIWjQ/9Y6gkv0XP6PXE+p2OW8ONdnpomkfV0CvLS\nUoTGP8kbmG3Os9++OZUiA9lDQuzsb+I5+szv4pglB8LeIqievZ6P7L8k3R34f82H\n8Es0ncUtLX/BOPrNU1WKLyyZ6PmVxmW/gtVceG7NAQKBgQD5BpK4Ee+ohKcCc5Hr\nPVxS0qQsoYCeAWxuImlFIvFMXdo37nMc8eE0HVZd/wYAZQ+338sap9mapZh7GMC6\nonf8pz8Cat/n/GAPSBK6XhWHUICjUTpQ20lEwz6AcrfuVbRxUW0nWwcXJXfqvoD8\nXgZDwBB2aBbD5Ap70UEx/ovSaQKBgQDI4AG1gZ7gkWeiNZfozfnnY61PepDlq+rQ\nBkA4kAkFf6QZ2JnAA2R+bjLSKIHNYPcfzCmFjeBJBSQYpx7Mqh/xrGLFnVzEh1X4\nek8w3nJ3w8Ei2RbV8Y0TdVcL4vGCcBOXIJXUBMEvmd60q0U39gshBxd9HnxSqX1l\nBI8xCrkzQQKBgE8K+RMYDlwNDv3GNTDX3zAi0B2ifbKpfQNQRN2/A5xbxeIu+7ba\nR8NE9J8NTZhee6i/jjY9xOJDYazg5HvZCgDWDTf1OHDoOI1hMSCasHas5MfyBnKX\nyB/dYT9gKmWqKoY1dFIjoJKGQBPwt/xi09Y5ZoBO9brj7Tfz6Z+2zibRAoGBAIVK\nVvf4tdLvySOSimV5X+0RcCv/+WvdIue8bhraQJI8e0iHOKZ32dQnDWP0awU75V9d\nGuQ7G2t4lNYi9sX50U6NA9F7NNZXs00445la0fv0khCsmoGGUgVqZENH6NeTxPwQ\nLDtOmF4crPGXgEu84O+ehBCLDRXQz5sbZmS1Z+TBAoGABTJIeJlLy+SWGJmLBr1b\nmMwySD6nRZYBLL/v+UONjLAbZGr7i0sJvKHw4IOSo+P1mf+YF3G31iOemm0ZugUT\nDwzStEZrKSiUfuiFyDN80m3Wj62cJhiZjVJfpp+CUoNIo4GJoV2tjJGo0fSOXqCh\n+q00enwFhO9gm0wchI/wslI=\n-----END PRIVATE KEY-----\n",
  "client_email": "newcapstonegsheets@capstonemapapi-382008.iam.gserviceaccount.com",
  "client_id": "110691024782823365143",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/newcapstonegsheets%40capstonemapapi-382008.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
  }
  ''';
  static final dataGSheets = GSheets(_credentials);
}
class RealDataSetService {
  final String _spreadsheetId = '1JXnZLWDw_uF5h9--1t6r2yLQappqFUGnSE1J3c5xt1I';
}

class _googleMapPageState extends State<googleMapPage> {
  double currentLatitude = 0;
  double currentLongitude = 0;
  late GoogleMapController mapController;
  bool _myLocationEnabled = false;
  late Uint8List markerIcon1,markerIcon2,markerIcon3,markerIcon4;

  final LatLng _center = const LatLng(37.5580918, 126.9982178);
  final Set<Marker> _markers = {};
  List<Map<String, dynamic>> _csvData = [];
  List<Map<String, dynamic>> _gsheetData = [];


  var userInfoName = "";
  var userInfoUid = "";
  var userInfoEmail = "";
  var userInfoPhoto = "";

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
      userInfoName = name;
      userInfoUid = uid;
      userInfoEmail = email;
      userInfoPhoto = photo;
    });
  }

  
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    get_gsheet().then((_) {
      _loadMarkers();
    });
    setCustomMapPin();
    bringData();
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentLatitude = position.latitude;
    currentLongitude = position.longitude;
    final LatLng currentLocation =
        LatLng(position.latitude, position.longitude);
    final cameraPosition = CameraPosition(
      bearing: 0,
      target: currentLocation,
      zoom: 17,
    );
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    setState(() {
      _myLocationEnabled = true;
    });
    _loadMarkers();
  }

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

  logoutAccount() async {
    // 로그아웃 함수
    await GoogleSignIn().signOut(); // 계정 선택
    await FirebaseAuth.instance.signOut();

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const googleMapPage()),
            (Route<dynamic> route) => false);
  }

  void _loadMarkers() {
    List<Marker> markers = [];
    double distanceInMeters;
    if (_myLocationEnabled == true) {
      for (var i = 0; i < _gsheetData.length; i++) {
        final name = _gsheetData[i]['name'];
        final latitude = _gsheetData[i]['latitude'];
        final longitude = _gsheetData[i]['longitude'];
        final address = _gsheetData[i]['address'];
        final category = _gsheetData[i]['category'];
        distanceInMeters = Geolocator.distanceBetween(
            currentLatitude, currentLongitude, latitude, longitude);
        if (distanceInMeters <= 500) {
          if (category == "편의점") {
            markers.add(
              Marker(
                markerId: MarkerId(name),
                icon: BitmapDescriptor.fromBytes(markerIcon1),
                position: LatLng(latitude, longitude),
                infoWindow: InfoWindow(
                  title: name,
                  snippet: address,
                ),
              ),
            );
          } else if (category=="대형마트") {
            markers.add(
              Marker(
                markerId: MarkerId(name),
                icon: BitmapDescriptor.fromBytes(markerIcon2),
                position: LatLng(latitude, longitude),
                infoWindow: InfoWindow(
                  title: name,
                  snippet: address,
                ),
              ),
            );
          } else if (category == "음식점") {
            markers.add(
              Marker(
                markerId: MarkerId(name),
                icon: BitmapDescriptor.fromBytes(markerIcon3),
                position: LatLng(latitude, longitude),
                infoWindow: InfoWindow(
                  title: name,
                  snippet: address,
                ),
              ),
            );
          } else {
            markers.add(
                Marker(
                  markerId: MarkerId(name),
                  icon: BitmapDescriptor.fromBytes(markerIcon4),
                  position: LatLng(latitude, longitude),
                  infoWindow: InfoWindow(
                    title: name,
                    snippet: address,
                  ),
                ),
            );
          }
        }
        setState(() {
          _markers.addAll(markers);
        });
      }
    }
  }

  Future<void> get_gsheet() async {
    const credentials = r'''
      {
        "type": "service_account",
        "project_id": "capstonemapapi-382008",
        "private_key_id": "215e01cca1759d3a79de65abe105fed59e650844",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDDZwoJxWI+AjU1\nJfv2SKH+o4gQUViiRrS/2tGihd3JktNgMxLWqAFMQrSZO19QzpRJqeA5y1qn/xKV\nFLD7EJ3O9RlNDYyHyK5gKilzzRZRnbJEnR/0NsH+QU0sLTB2u/Xr8BBd9kx1Gv1b\nUeN1OCwNEHLkT8YUMiIYtmm8v5xBppi4tL+28ZWX5yM/87KZ9utgOKGQ/6wnp/mz\nmzdJhkOL11fRNgCDiFvbZbY0K+yVq8zeRjXJryy012eviMepDUP3jSzOMjrNZoTg\nwiauMHVy7/95kwB9c+88H8FjZLh7tqYGz2f2hR2HAboYBOTHpB672e0OMRE+Ubsg\n2cOkTFepAgMBAAECggEABKaWrWiGb+hjNiUgdppVn2HACCIPhH6UqGj/tVO6ACVf\npOSs+EaeZUoZ0fiA9RjoRvU6nNWIuQKQAX6xFFYEaNvE4uRwKakum/j/lz3UiqkW\nCEkJwikYJpeM9oC1gcCegqOU7XpCaUUfrkU9hIQ2Ptywh1uYtiatUL5Ct6yDKRLQ\neXGDKEwgDOpyCjUQItU98jvfVIWjQ/9Y6gkv0XP6PXE+p2OW8ONdnpomkfV0CvLS\nUoTGP8kbmG3Os9++OZUiA9lDQuzsb+I5+szv4pglB8LeIqievZ6P7L8k3R34f82H\n8Es0ncUtLX/BOPrNU1WKLyyZ6PmVxmW/gtVceG7NAQKBgQD5BpK4Ee+ohKcCc5Hr\nPVxS0qQsoYCeAWxuImlFIvFMXdo37nMc8eE0HVZd/wYAZQ+338sap9mapZh7GMC6\nonf8pz8Cat/n/GAPSBK6XhWHUICjUTpQ20lEwz6AcrfuVbRxUW0nWwcXJXfqvoD8\nXgZDwBB2aBbD5Ap70UEx/ovSaQKBgQDI4AG1gZ7gkWeiNZfozfnnY61PepDlq+rQ\nBkA4kAkFf6QZ2JnAA2R+bjLSKIHNYPcfzCmFjeBJBSQYpx7Mqh/xrGLFnVzEh1X4\nek8w3nJ3w8Ei2RbV8Y0TdVcL4vGCcBOXIJXUBMEvmd60q0U39gshBxd9HnxSqX1l\nBI8xCrkzQQKBgE8K+RMYDlwNDv3GNTDX3zAi0B2ifbKpfQNQRN2/A5xbxeIu+7ba\nR8NE9J8NTZhee6i/jjY9xOJDYazg5HvZCgDWDTf1OHDoOI1hMSCasHas5MfyBnKX\nyB/dYT9gKmWqKoY1dFIjoJKGQBPwt/xi09Y5ZoBO9brj7Tfz6Z+2zibRAoGBAIVK\nVvf4tdLvySOSimV5X+0RcCv/+WvdIue8bhraQJI8e0iHOKZ32dQnDWP0awU75V9d\nGuQ7G2t4lNYi9sX50U6NA9F7NNZXs00445la0fv0khCsmoGGUgVqZENH6NeTxPwQ\nLDtOmF4crPGXgEu84O+ehBCLDRXQz5sbZmS1Z+TBAoGABTJIeJlLy+SWGJmLBr1b\nmMwySD6nRZYBLL/v+UONjLAbZGr7i0sJvKHw4IOSo+P1mf+YF3G31iOemm0ZugUT\nDwzStEZrKSiUfuiFyDN80m3Wj62cJhiZjVJfpp+CUoNIo4GJoV2tjJGo0fSOXqCh\n+q00enwFhO9gm0wchI/wslI=\n-----END PRIVATE KEY-----\n",
        "client_email": "newcapstonegsheets@capstonemapapi-382008.iam.gserviceaccount.com",
        "client_id": "110691024782823365143",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/newcapstonegsheets%40capstonemapapi-382008.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      }
      ''';

    final gsheets = GSheets(credentials);
    final spreadsheet = await gsheets.spreadsheet('1NfTbHtaI6g9GLmtd3GOQ7CM4wLT_mGTOoDfSsq5ZizY');

    final worksheet = spreadsheet.worksheetByTitle('시트1');
    final valueRange = await worksheet?.values.allRows();
    final data = valueRange?.map((row) => List<dynamic>.from(row)).toList();

    var srcProj = Projection.add('EPSG:2097',
        '+proj=tmerc +lat_0=38 +lon_0=127.0028902777778 +k=1 +x_0=200000 +y_0=500000 +ellps=bessel +units=m +no_defs +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43');
    var dstnProj = Projection.get('EPSG:4326')!;

    List<List>? rowsAsListOfValues = data;
    List<List<dynamic>> dataWithoutHeader = rowsAsListOfValues!.sublist(1);
    _gsheetData = dataWithoutHeader.map((row) {
      final epsg2097Coords = Point(x:double.parse(row[4].toString()), y:double.parse(row[5].toString()));
      final latLong=srcProj.transform(dstnProj, epsg2097Coords);
      return{
        'name':row[0],
        'latitude':latLong.toArray()[1],
        'longitude':latLong.toArray()[0],
        'address':row[3],
        'category':row[1]
      };
    }).toList();
  }

  void setCustomMapPin() async{
    markerIcon1=await getBytesFromAsset('marker_images/green.png',5);
    markerIcon2=await getBytesFromAsset('marker_images/purple.png',5);
    markerIcon3=await getBytesFromAsset('marker_images/red.png',5);
    markerIcon4=await getBytesFromAsset('marker_images/blue.png',1);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Map<String, bool> filters = {
    "편의점": true,
    "대형마트": true,
    "카페": true,
    "백화점": true,
    "음식점": true,
  };

  List<Icon> icons = [
    Icon(Icons.store),
    Icon(Icons.local_grocery_store),
    Icon(Icons.local_cafe),
    Icon(Icons.local_mall),
    Icon(Icons.restaurant)
  ];

  Widget webDrawer() {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey[850],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Column(
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                  ),
                  accountName: Text(
                    '사용자 이름 : ${userInfoName}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  accountEmail: Text(
                      '사용자 이메일 : ${userInfoEmail}',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.grey[850],
                    size: 25,
                  ),
                  title: Text('Home'),
                  onTap: (){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    const googleMapPage()), (Route<dynamic> route) => false);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.space_dashboard_outlined,
                    color: Colors.grey[850],
                    size: 25,
                  ),
                  title: Text('Time'),
                  onTap: (){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    const googleMapPage()), (Route<dynamic> route) => false);
                  },
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.list_bullet,
                    color: Colors.grey[850],
                    size: 25,
                  ),
                  title: Text('List'),
                  onTap: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                        freeForum()));
                  },
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.bell,
                    color: Colors.grey[850],
                    size: 25,
                  ),
                  title: Text('Alert'),
                  onTap: (){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    const googleMapPage()), (Route<dynamic> route) => false);
                  },
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.location,
                    color: Colors.grey[850],
                    size: 25,
                  ),
                  title: Text('Campic'),
                  onTap: (){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                    const ProfilePage()), (Route<dynamic> route) => false);
                  },
                ),
                (FirebaseAuth.instance.currentUser == null) ?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
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
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(50)
                          ),
                        ),
                        side: const BorderSide(
                          color: Colors.grey,
                        )
                    ),
                    child: Container(
                      height: 55,
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children:  [
                          Container(
                            width: 22,
                            height: 22,
                            child: const Image(
                              image: AssetImage('google_icon.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text("구글 로그인",
                            style: TextStyle(
                                color: Colors.black,
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
                ) : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if(!context.mounted) {
                        return ;
                      }
                      await logoutAccount();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0.0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(50)
                          ),
                        ),
                        side: const BorderSide(
                          color: Colors.grey,
                        )
                    ),
                    child: Container(
                      height: 55,
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children:  [
                          Container(
                            width: 22,
                            height: 22,
                            child: const Image(
                              image: AssetImage('google_icon.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text("로그아웃",
                            style: TextStyle(
                                color: Colors.black,
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
                ),

              ],
            ),
          ],
        ),
      ),
      body: Stack(children: [
        GoogleMap(
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 16.0,
          ),
          markers: _markers.toSet(),
          myLocationEnabled: _myLocationEnabled,
          compassEnabled: true,
          myLocationButtonEnabled: false,
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: SizedBox(
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              elevation: 8,
              // 그림자 크기
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글기
              ),
              child: Icon(Icons.my_location),
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView.builder(
            //padding: new EdgeInsets.all(10.0), //묶인 카테고리 주변에 다 10만큼
            scrollDirection: Axis.horizontal,
            itemCount: filters.entries.length, //총 갯수
            itemBuilder: (context, index) {
              return Padding(
                //index번째의 view, 0부터 시작
                padding: new EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () => setState(() =>
                  filters[filters.keys.elementAt(index)] =
                  !filters.values.elementAt(index)),
                  child: Chip(
                      avatar: icons[index],
                      padding: new EdgeInsets.all(5.0),
                      elevation: 8,
                      backgroundColor: filters.values.elementAt(index)
                          ? Colors.white
                          : Colors.grey,
                      label: Text(filters.keys.elementAt(index))),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }

  Widget appBottom() {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 16.0,
          ),
          markers: _markers.toSet(),
          myLocationEnabled: _myLocationEnabled,
          compassEnabled: true,
          myLocationButtonEnabled: false,
        ),
        Positioned(
          bottom: 16,
          left: 16,
          child: SizedBox(
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              elevation: 8,
              // 그림자 크기
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // 버튼 모서리 둥글기
              ),
              child: Icon(Icons.my_location),
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            //padding: new EdgeInsets.all(10.0), //묶인 카테고리 주변에 다 10만큼
            scrollDirection: Axis.horizontal,
            itemCount: filters.entries.length, //총 갯수
            itemBuilder: (context, index) {
              return Padding(
                //index번째의 view, 0부터 시작
                padding: new EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () => setState(() =>
                  filters[filters.keys.elementAt(index)] =
                  !filters.values.elementAt(index)),
                  child: Chip(
                      avatar: icons[index],
                      padding: new EdgeInsets.all(5.0),
                      elevation: 8,
                      backgroundColor: filters.values.elementAt(index)
                          ? Colors.white
                          : Colors.grey,
                      label: Text(filters.keys.elementAt(index))),
                ),
              );
            },
          ),
        ),
      ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? webDrawer() : appBottom();
  }
}
