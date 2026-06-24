import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart'  hide LocationAccuracy;
import 'package:silent_talk/core/utils/location/location_cache.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/api_consts.dart';
import '../../../features/auth/services/authenticator.dart';
import '../../../features/chat/services/send_messages.dart';

class MapSample extends StatefulWidget {
  final String receiverId;
  final double latitude;
  final double longitude;

  const MapSample({
    super.key,
    required this.receiverId,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late final Location _location;
  LatLng? currentPosition;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  late CameraPosition _kGooglePlex;
  // LatLng? _markerPosition;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
 late LatLng _markerPosition ;
  @override
  void initState() {
    super.initState();
    _location = Location();
    _markerPosition = LatLng(widget.latitude, widget.longitude);
    _gsetMarker(_markerPosition);
    _kGooglePlex = CameraPosition(
      target: _markerPosition,
      zoom: 14.4746,
    );
  }
  // 1. Current location
  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentPosition = LatLng(position.latitude, position.longitude);

    setState(() {
      markers.add(
        Marker(markerId: MarkerId("start"), position: currentPosition!),
      );

      markers.add(Marker(markerId: MarkerId("end"), position: _markerPosition));
    });

    await getRoute();
  }
  // 2. Google Directions API
  Future<void> getRoute() async {
    final apiKey = Keys().googleMapKey;

    final url =
        "https://maps.googleapis.com/maps/api/directions/json?"
        "origin=${currentPosition!.latitude},${currentPosition!.longitude}"
        "&destination=${_markerPosition.latitude},${_markerPosition.longitude}"
        "&key=$apiKey";

    final response = await http.get(Uri.parse(url));
    final data = jsonDecode(response.body);

    final points = data["routes"][0]["overview_polyline"]["points"];

    List<LatLng> routeCoords = decodePolyline(points);

    setState(() {
      polylines.add(
        Polyline(
          polylineId: PolylineId("route"),
          points: routeCoords,
          color: Colors.blue,
          width: 5,
        ),
      );
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
  void _gsetMarker(LatLng position) {
    setState(() {
      markers = {
      Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
          draggable: true,
          onDragEnd: (newPosition) {
            _markerPosition = newPosition;
            _gsetMarker(newPosition); // Update marker after drag
          },
        ),
      };
    });
  }

  void _onMapTapped(LatLng position) {
    _markerPosition = position;
    _gsetMarker(position); // Update marker on map tap
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        padding: EdgeInsets.only(top: 500),
        markers: markers,
        mapType:MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (controller) => _controller.complete(controller),
        onTap: _onMapTapped,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        buildingsEnabled: true,
        trafficEnabled: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _sendLocation(widget.receiverId);
        },
        label: const Text('Send Location!'),
        icon: const Icon(Icons.location_on_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterTop,
    );
  }

  void _sendLocation(String receiverId) {
    if (_markerPosition != null) {
      final googleMapsUrl =
          "https://www.google.com/maps?q=${_markerPosition!.latitude},${_markerPosition!.longitude}";
      MessageService().sendMessage(
        googleMapsUrl,
        Authenticator().user!.uid,
        receiverId,
        "location",
      );
      LocationCache.save(_markerPosition!.latitude, _markerPosition!.longitude);
      if (!context.mounted) return;
      context.pop();
    }
  }
}

