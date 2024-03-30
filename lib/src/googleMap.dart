import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'gsheet_options.dart';


class googleMapPage extends StatefulWidget {
  const googleMapPage({Key? key}) : super(key: key);

  @override
  State<googleMapPage> createState() => _googleMapPageState();
}


class _googleMapPageState extends State<googleMapPage> {
  double currentLatitude = 0;
  double currentLongitude = 0;
  late GoogleMapController mapController;
  late LatLng centerPoint = LatLng(0, 0);
  late BitmapDescriptor markerAppIcon1,
      markerAppIcon2,
      markerAppIcon3,
      markerAppIcon4;

  bool _myLocationEnabled = false;
  bool _visible = false;
  double distanceMoving = 0;
  late Uint8List markerIcon1, markerIcon2, markerIcon3, markerIcon4;

  final LatLng _center = const LatLng(37.5580918, 126.9982178);
  final Set<Marker> _markers = {};
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
      setCustomMapPin();
      _loadMarkers();
    });
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
      _visible = false;
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

  Future<void> signInWithGoogleApp() async {
    //앱용 로그인 코드
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: ["email", "profile"]).signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential googleUserCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    // print(googleUserCredential.additionalUserInfo?.profile);
    // print(googleUserCredential.user?.email);

    DocumentSnapshot loginCheckDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

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
    setState(() {
      _markers.clear();
    });
    for (var i = 0; i < _gsheetData.length; i++) {
      final name = _gsheetData[i]['name'];
      final latitude = _gsheetData[i]['latitude'];
      final longitude = _gsheetData[i]['longitude'];
      final address = _gsheetData[i]['address'];
      final category = _gsheetData[i]['category'];
      distanceInMeters = Geolocator.distanceBetween(
          currentLatitude, currentLongitude, latitude, longitude);
      if (distanceInMeters <= 500) {
        if (category == "카페" && cafe) {
          markers.add(
            Marker(
              markerId: MarkerId(name),
              icon: kIsWeb
                  ? BitmapDescriptor.fromBytes(markerIcon1)
                  : markerAppIcon1,
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: name,
                snippet: address,
              ),
            ),
          );
          setState(() {
            _markers.addAll(markers);
          });
        } else if (category == "대형마트" && grocery) {
          markers.add(
            Marker(
              markerId: MarkerId(name),
              icon: kIsWeb
                  ? BitmapDescriptor.fromBytes(markerIcon2)
                  : markerAppIcon2,
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: name,
                snippet: address,
              ),
            ),
          );
          setState(() {
            _markers.addAll(markers);
          });
        } else if (category == "음식점" && restaurant) {
          markers.add(
            Marker(
              markerId: MarkerId(name),
              icon: kIsWeb
                  ? BitmapDescriptor.fromBytes(markerIcon3)
                  : markerAppIcon3,
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: name,
                snippet: address,
              ),
            ),
          );
          setState(() {
            _markers.addAll(markers);
          });
        } else if (category == "편의점" && store) {
          markers.add(
            Marker(
              markerId: MarkerId(name),
              icon: kIsWeb
                  ? BitmapDescriptor.fromBytes(markerIcon4)
                  : markerAppIcon4,
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: name,
                snippet: address,
              ),
            ),
          );
          setState(() {
            _markers.addAll(markers);
          });
        }
      }
    }
  }

  Future<void> get_gsheet() async {

    const credentials = gsheet_credentials;

    final gsheets = GSheets(credentials);
    final spreadsheet = await gsheets
        .spreadsheet(gsheet_id);

    final worksheet = spreadsheet.worksheetByTitle('시트1');
    final valueRange = await worksheet?.values.allRows();
    final data = valueRange?.map((row) => List<dynamic>.from(row)).toList();

    var srcProj = Projection.add('EPSG:2097',
        '+proj=tmerc +lat_0=38 +lon_0=127.0028902777778 +k=1 +x_0=200000 +y_0=500000 +ellps=bessel +units=m +no_defs +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43');
    var dstnProj = Projection.get('EPSG:4326')!;

    List<List>? rowsAsListOfValues = data;
    List<List<dynamic>> dataWithoutHeader = rowsAsListOfValues!.sublist(1);
    _gsheetData = dataWithoutHeader.map((row) {
      final epsg2097Coords = Point(
          x: double.parse(row[4].toString()),
          y: double.parse(row[5].toString()));
      final latLong = srcProj.transform(dstnProj, epsg2097Coords);
      return {
        'name': row[0],
        'latitude': latLong.toArray()[1],
        'longitude': latLong.toArray()[0],
        'address': row[3],
        'category': row[1]
      };
    }).toList();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void setCustomMapPin() async {
    if (kIsWeb) {
      markerIcon1 = await getBytesFromAsset('marker_images/green.png', 5);
      markerIcon2 = await getBytesFromAsset('marker_images/purple.png', 5);
      markerIcon3 = await getBytesFromAsset('marker_images/red.png', 5);
      markerIcon4 = await getBytesFromAsset('marker_images/blue.png', 1);
    } else {
      markerAppIcon1 =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      markerAppIcon2 =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
      markerAppIcon3 =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      markerAppIcon4 =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
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

  bool store = true;
  bool grocery = true;
  bool cafe = true;
  bool mall = true;
  bool restaurant = true;

  Map<String, bool> filters = {
    "편의점": true,
    "대형마트": true,
    "카페": true,
    "백화점": true,
    "음식점": true,
  };

  List<Icon> icons = [
    Icon(Icons.store, color: Colors.black),
    Icon(Icons.local_grocery_store, color: Colors.black),
    Icon(Icons.local_cafe, color: Colors.black),
    Icon(Icons.local_mall, color: Colors.black),
    Icon(Icons.restaurant, color: Colors.black)
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
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Icon(
                    Icons.map,
                    color: Colors.grey[850],
                    size: 25,
                  ),
                  title: Text('Home'),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const googleMapPage()),
                        (Route<dynamic> route) => false);
                  },
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.list_bullet,
                    color: Colors.grey[850],
                    size: 25,
                  ),
                  title: Text('Community'),
                  onTap: () async {
                    (FirebaseAuth.instance.currentUser != null)
                        ? Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => freeForum()),
                    )
                        : kIsWeb
                        ? await signInWithGoogleWeb()
                        : await signInWithGoogleApp();

                    if(FirebaseAuth.instance.currentUser != null){
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => freeForum()),
                      );
                    }
                  },
                ),
                ListTile(
                  leading: Icon(
                    CupertinoIcons.profile_circled,
                    color: Colors.grey[850],
                    size: 25,
                  ),
                  title: Text('Mypage'),
                  onTap: () async {
                    (FirebaseAuth.instance.currentUser != null)
                        ? Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()),
                          )
                        : kIsWeb
                            ? await signInWithGoogleWeb()
                            : await signInWithGoogleApp();
                    if(FirebaseAuth.instance.currentUser != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ProfilePage()),
                      );
                    }
                  },
                ),
                (FirebaseAuth.instance.currentUser == null)
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!context.mounted) {
                              return;
                            }
                            // showAlertDialog();
                            // await signInWithGoogle();
                            kIsWeb
                                ? await signInWithGoogleWeb()
                                : await signInWithGoogleApp();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const googleMapPage()),
                                (Route<dynamic> route) => false);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0.0,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              side: const BorderSide(
                                color: Colors.grey,
                              )),
                          child: Container(
                            height: 55,
                            width: 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  child: const Image(
                                    image: AssetImage('google_icon.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Text(
                                  "구글 로그인",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!context.mounted) {
                              return;
                            }
                            await logoutAccount();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0.0,
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              side: const BorderSide(
                                color: Colors.grey,
                              )),
                          child: Container(
                            height: 55,
                            width: 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 22,
                                  height: 22,
                                  child: const Image(
                                    image: AssetImage('google_icon.png'),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                Text(
                                  "로그아웃",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                      height: 1.5),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
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
          onCameraMove: (CameraPosition cameraPosition) =>
              centerPoint = cameraPosition.target,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 16.0,
          ),
          markers: _markers.toSet(),
          myLocationEnabled: _myLocationEnabled,
          compassEnabled: true,
          myLocationButtonEnabled: false,
        ),
        GestureDetector(
          onPanUpdate: (details) {
            distanceMoving = Geolocator.distanceBetween(currentLatitude,
                currentLongitude, centerPoint.latitude, centerPoint.longitude);
            if (distanceMoving >= 450) {
              setState(() {
                _visible = true;
              });
            }
          },
        ),
        Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 16),
            child: Visibility(
              visible: _visible,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          //모서리를 둥글게
                          borderRadius: BorderRadius.circular(50)),
                      side: BorderSide(width: 0.5, color: Colors.black)),
                  onPressed: () {
                    currentLatitude = centerPoint.latitude;
                    currentLongitude = centerPoint.longitude;
                    _loadMarkers();
                  },
                  icon: Icon(Icons.refresh, color: Colors.black),
                  label: Text('현재위치에서 재검색',
                      style: TextStyle(color: Colors.black))),
            )),
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
            scrollDirection: Axis.horizontal,
            itemCount: filters.entries.length, //총 갯수
            itemBuilder: (context, index) {
              return Padding(
                //index번째의 view, 0부터 시작
                padding: new EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      filters[filters.keys.elementAt(index)] =
                          !filters.values.elementAt(index);
                      if (index == 0) store = !store;
                      if (index == 1) grocery = !grocery;
                      if (index == 2) cafe = !cafe;
                      if (index == 3) mall = !mall;
                      if (index == 4) restaurant = !restaurant;
                      _loadMarkers();
                    });
                  },
                  child: Chip(
                      avatar: icons[index],
                      padding: new EdgeInsets.all(5.0),
                      side: BorderSide(width: 0.5, color: Colors.black),
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
          onCameraMove: (CameraPosition cameraPosition) =>
              centerPoint = cameraPosition.target,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 16.0,
          ),
          markers: _markers.toSet(),
          myLocationEnabled: _myLocationEnabled,
          compassEnabled: true,
          myLocationButtonEnabled: false,
        ),
        GestureDetector(
          onPanUpdate: (details) {
            distanceMoving = Geolocator.distanceBetween(currentLatitude,
                currentLongitude, centerPoint.latitude, centerPoint.longitude);
            if (distanceMoving >= 450) {
              setState(() {
                _visible = true;
              });
            }
          },
        ),
        Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 16),
            child: Visibility(
              visible: _visible,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          //모서리를 둥글게
                          borderRadius: BorderRadius.circular(50)),
                      side: BorderSide(width: 0.5, color: Colors.black)),
                  onPressed: () {
                    currentLatitude = centerPoint.latitude;
                    currentLongitude = centerPoint.longitude;
                    _loadMarkers();
                  },
                  icon: Icon(Icons.refresh, color: Colors.black),
                  label: Text('현재위치에서 재검색',
                      style: TextStyle(color: Colors.black))),
            )),
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
                  onTap: () {
                    setState(() {
                      filters[filters.keys.elementAt(index)] =
                          !filters.values.elementAt(index);
                      if (index == 0) store = !store;
                      if (index == 1) grocery = !grocery;
                      if (index == 2) cafe = !cafe;
                      if (index == 3) mall = !mall;
                      if (index == 4) restaurant = !restaurant;
                      _loadMarkers();
                    });
                  },
                  child: Chip(
                      avatar: icons[index],
                      padding: new EdgeInsets.all(5.0),
                      side: BorderSide(width: 0.5, color: Colors.black),
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

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? webDrawer() : appBottom();
  }
}
