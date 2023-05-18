import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:csv/csv.dart';
import 'package:proj4dart/proj4dart.dart';


class googleMapPage extends StatefulWidget {
  const googleMapPage({Key? key}) : super(key: key);

  @override
  State<googleMapPage> createState() => _googleMapPageState();
}

class _googleMapPageState extends State<googleMapPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(37.5580918, 126.9982178);
  final Set<Marker> _markers = {};
  List<Map<String,dynamic>> _csvData=[];

  @override
  void initState() {
    super.initState();
    _readCsv().then((_){
      _loadMarkers();
    });
  }

  Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  Future<void> _readCsv() async {
    var srcProj=Projection.add('EPSG:2097','+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=500000 +ellps=bessel +units=m +no_defs +towgs84=-115.80,474.99,674.11,1.16,-2.31,-1.63,6.43');
    var dstnProj=Projection.get('EPSG:4326')!;
    final csvData = await rootBundle.loadString('data_prototype_utf-8.csv');
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvData);
    List<List<dynamic>> dataWithoutHeader = rowsAsListOfValues.sublist(1);
    _csvData = dataWithoutHeader.map((row) {
      final epsg2097Coords = Point(x:double.parse(row[3].toString()), y:double.parse(row[4].toString()));
      final latLong=srcProj.transform(dstnProj, epsg2097Coords);
      return{
        'name':row[0],
        'latitude':latLong.toArray()[1],
        'longitude':latLong.toArray()[0],
        'address':row[2]
      };
    }).toList();
  }

  void _loadMarkers() {
    List<Marker> markers = [];
    for (var i=0;i<_csvData.length;i++) {
      final name=_csvData[i]['name'];
      final latitude=_csvData[i]['latitude'];
      final longitude=_csvData[i]['longitude'];
      final address=_csvData[i]['address'];
      markers.add(
        Marker(
          markerId: MarkerId(name),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: name,
            snippet: address,
          ),
        ),
      );
    }

    setState(() {
      _markers.addAll(markers);
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 16.0,
        ),
        markers: _markers.toSet(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          setState(() {});
        },
        label: Text('버튼 테스트'),
      ),
    );
  }
}




