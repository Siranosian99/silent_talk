import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'constants/api_consts.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  LatLng? currentPosition;
  LatLng destination = LatLng(40.2010, 44.5500); // message location

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  // 1. Current location
  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentPosition = LatLng(position.latitude, position.longitude);

    setState(() {
      markers.add(Marker(
        markerId: MarkerId("start"),
        position: currentPosition!,
      ));

      markers.add(Marker(
        markerId: MarkerId("end"),
        position: destination,
      ));
    });

    await getRoute();
  }

  // 2. Google Directions API
  Future<void> getRoute() async {
    final apiKey = Keys().googleMapKey;

    final url =
        "https://maps.googleapis.com/maps/api/directions/json?"
        "origin=${currentPosition!.latitude},${currentPosition!.longitude}"
        "&destination=${destination.latitude},${destination.longitude}"
        "&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    final points = data["routes"][0]["overview_polyline"]["points"];

    List<LatLng> routeCoords = decodePolyline(points);

    setState(() {
      polylines.add(Polyline(
        polylineId: PolylineId("route"),
        points: routeCoords,
        color: Colors.blue,
        width: 5,
      ));
    });
  }

  // 3. Decode polyline
  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: currentPosition!,
          zoom: 14,
        ),
        markers: markers,
        polylines: polylines,
        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }
}