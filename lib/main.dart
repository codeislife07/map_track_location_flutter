import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_track_location_flutter/constant_v.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Track Location'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Completer<GoogleMapController> controller = Completer();

  static const LatLng sourceDestination = LatLng(22.3179263, 70.7662879);
  static const LatLng sourceLocation = LatLng(22.2437369, 70.7965411);

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polylinePoits = PolylinePoints();
    PolylineResult result = await polylinePoits.getRouteBetweenCoordinates(
      googleApiKey: API_KEY,
      request: PolylineRequest(
        origin: PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
        destination: PointLatLng(
            sourceDestination.latitude, sourceDestination.longitude),
        mode: TravelMode.driving,
      ),
    );
    if (result.points.isNotEmpty) {
      for (var element in result.points) {
        polylineCoordinates.add(LatLng(element.latitude, element.longitude));
      }
    }
    setState(() {
      
    });
  }

  @override
  void initState() {
   
    super.initState();
     getPolyPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: sourceLocation,
          zoom: 12,
        ),
        polylines: {
          Polyline(
              polylineId: const PolylineId("route"),
              points: polylineCoordinates)
        },
        markers: {
          const Marker(
            markerId: MarkerId("source"),
            position: sourceLocation,
          ),
          const Marker(
            markerId: MarkerId("destination"),
            position: sourceDestination,
          ),
        },
      ),
    );
  }
}
