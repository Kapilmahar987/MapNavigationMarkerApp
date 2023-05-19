import 'dart:async';
import 'dart:developer';
import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserCurrentLocation extends StatefulWidget {
  const UserCurrentLocation({super.key});

  @override
  State<UserCurrentLocation> createState() => _UserCurrentLocationState();
}

class _UserCurrentLocationState extends State<UserCurrentLocation> {
  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex =
  CameraPosition(target: LatLng(23.1817690, 77.3019810), zoom: 14);
  final Set<Polyline> _polyline = {};

  final List<Marker> _markers = <Marker>[
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(23.1817690, 77.3019810),
      infoWindow: InfoWindow(title: "MY Location"),
    ),
  ];

  List<LatLng> latlng = [
    LatLng(23.1817690, 77.3019810),
    LatLng(23.1820867, 77.3023018),
    LatLng(23.1818331, 77.3018043),
    //   LatLng(23.18180, 77.30219),
    //   LatLng(23.18180, 77.30201),
    //   LatLng(23.18180, 77.30198),
    //   LatLng(23.18183, 77.30197),
    //   LatLng(23.18184, 77.30191),
    //   LatLng(23.18184, 77.30180),
    //   LatLng(23.18184, 77.30167),
    //   LatLng(23.18168, 77.30173),
    //   LatLng(23.18161, 77.30172),
    //   LatLng(23.18157, 77.30161),
    //   LatLng(23.18158, 77.30162),
    //   LatLng(23.18153, 77.30161),
    //   LatLng(23.18147, 77.30158),
    //   LatLng(23.18150, 77.30151),
    //   LatLng(23.18151, 77.30146),
    //   LatLng(23.18156, 77.30151),
  ];

  List<Marker> _marker = [];
  final List<Marker> _list = const [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(23.1817690, 77.3019810),
      infoWindow: InfoWindow(title: "MY Location"),
    ),
    Marker(
      markerId: MarkerId('2'),
      position: LatLng(23.1820867, 77.3023018),
      infoWindow: InfoWindow(title: "SISTec-R"),
    ),
    Marker(
      markerId: MarkerId('3'),
      position: LatLng(23.1818331, 77.3018043),
      infoWindow: InfoWindow(title: "CSE"),
    ),
  ];

  double? latitude;
  double? longitude;

  loadData() {
    getUserCurrentLocation().then((value) async {
      log("my current Location in load data");
      latitude = value.latitude;
      longitude = value.longitude;
      log(value.latitude.toString() + "" + value.longitude.toString());
      _markers.add(Marker(
        markerId: MarkerId('2'),
        position: LatLng(value.latitude, value.longitude),
      ));

      //changes are made here
// Assuming you have a list of markers and the user's current location

      Location location = Location();
      double proximityRange = 90;

      for (Marker marker in _list) {
        log("I'm in loop");
        LatLng markerPosition = marker.position;
        double marker_latitude = markerPosition.latitude;
        double marker_longitude = markerPosition.longitude;

        log("Markers Data: \n marker latitude: "+(marker_latitude).toStringAsFixed(4));
        log("marker longitude: "+(marker_longitude).toStringAsFixed(4));


        // double distance = await location.distanceBetween(
        //   latitude,
        //   longitude,
        //   marker_latitude,
        //   marker_longitude,
        // );



        double calculateDistance(lat1, lon1, lat2, lon2) {

          log("calculate distance is called");

          log("Distance: "+(Geolocator.distanceBetween(lat1, lon1, lat2, lon2)).toStringAsFixed(5));

          return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);

         // log((Geolocator.distanceBetween(lat1, lon1, lat2, lon2)).toStringAsFixed(5));

          // var p = 0.017453292519943295;
          // var c = cos;
          // var a = 0.5 -
          //     c((lat2 - lat1) * p) / 2 +
          //     c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
          // log((1000 * 12742 * asin(sqrt(a))).toStringAsFixed(4));
          //
          // return 1000 * 12742 * asin(sqrt(a));

        }

        double distance = calculateDistance(
            latitude, longitude, marker_latitude, marker_longitude);

        log("latitude longitude marker code is down if distance Is calculated: ");
     // log(distance as String);

        if (distance <= proximityRange) {
          log("Point reached");
          // Show the text box or widget associated with the marker
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text((marker.infoWindow.title).toString()),
          ));
        }
      }

      //upto here

      CameraPosition cameraPosition = CameraPosition(
        zoom: 14,
        target: LatLng(value.latitude, value.longitude),
      );
      final GoogleMapController controller = await _controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error" + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    for (int i = 0; i < latlng.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId(i.toString()),
        position: latlng[i],
        infoWindow: InfoWindow(
          title: 'HOTEL',
          snippet: '5 Star Hotel',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      setState(() {});
      _polyline.add(Polyline(
        polylineId: PolylineId('1'),
        points: latlng,
        color: Color.fromARGB(255, 7, 193, 240),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          markers: Set<Marker>.of(_markers),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          polylines: _polyline,
          myLocationEnabled: true,
          mapType: MapType.normal,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getUserCurrentLocation().then((value) async {
            log("my current Location on button press");
            log(value.latitude.toString() + "" + value.longitude.toString());

            _markers.add(Marker(
              markerId: MarkerId('2'),
              position: LatLng(value.latitude, value.longitude),
            ));

            CameraPosition cameraPosition = CameraPosition(
              zoom: 14,
              target: LatLng(value.latitude, value.longitude),
            );
            final GoogleMapController controller = await _controller.future;

            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
          });
        },
        child: Icon(Icons.local_activity),
      ),
    );
  }
}
