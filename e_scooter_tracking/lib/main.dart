import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Completer<GoogleMapController> _controller = Completer();
  late BitmapDescriptor _scooterIcon;
  Position? _currentPosition;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.fromAssetImage(
  ImageConfiguration(size: Size(1, 1)),
  'assets/images/scooter.png',
).then((icon) => _scooterIcon = icon);


    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    await Geolocator.requestPermission();
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 11.0,
        ),
        zoomControlsEnabled: false, // Disable zoom controls
        markers: _currentPosition == null
            ? <Marker>{}
            : <Marker>{
                Marker(
  markerId: const MarkerId('current_position'),
  position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
  icon: _scooterIcon,
  anchor: const Offset(0.5, 0.5),
),

              },
        circles: _currentPosition == null
            ? <Circle>{}
            : <Circle>{
                Circle(
                  circleId: const CircleId('current_position_circle'),
                  center:
                      LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                  radius: 2000, // 2km
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              },
      ),
    );
  }
}
