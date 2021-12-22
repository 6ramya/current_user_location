import 'dart:async';
import 'package:current_user_location/user_location.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late LatLng latLng;
  late GoogleMapController newGoogleMapController;
  late Position currentPosition;

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLng, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  static final CameraPosition _kGoogleFlex =
      CameraPosition(target: LatLng(19.0596, 72.8295), zoom: 11);
  Widget buildMap() {
    return GoogleMap(
        mapType: MapType.normal,
        myLocationButtonEnabled: true,
        initialCameraPosition: _kGoogleFlex,
        zoomControlsEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controllerGoogleMap.complete(controller);
          newGoogleMapController = controller;
          getCurrentLocation();
        });
  }

  @override
  void initState() {
    AccessLocation().requestLocationPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User Location'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: buildMap()),
              FlatButton(
                  onPressed: () {
                    getCurrentLocation();
                  },
                  color: Colors.blue,
                  child: Text('Get User Location'))
            ],
          ),
        ));
  }
}
