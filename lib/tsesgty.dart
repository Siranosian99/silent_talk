import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:apple_maps_flutter/apple_maps_flutter.dart' as amaps;
import 'package:go_router/go_router.dart';
import 'features/auth/services/authenticator.dart';
import 'features/chat/services/send_messages.dart';

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
  State<MapSample> createState() => _MapSampleState();
}

class _MapSampleState extends State<MapSample> {
  late final Location _location;
  gmaps.LatLng? _gMarkerPosition;
  amaps.LatLng? _aMarkerPosition;

  Set<gmaps.Marker> _gMarkers = {};
  Set<amaps.Annotation>? _aAnnotations;

  amaps.AppleMapController? _appleMapController;
  final Completer<gmaps.GoogleMapController> _googleController =
  Completer<gmaps.GoogleMapController>();

  late gmaps.CameraPosition _kGooglePlex;
  late amaps.CameraPosition _kApplePlex;

  @override
  void initState() {
    super.initState();
    _location = Location();

    _gMarkerPosition = gmaps.LatLng(widget.latitude, widget.longitude);
    _aMarkerPosition = amaps.LatLng(widget.latitude, widget.longitude);

    _gSetMarker(_gMarkerPosition!);
    _aSetMarker(_aMarkerPosition!);

    _kGooglePlex = gmaps.CameraPosition(
      target: _gMarkerPosition!,
      zoom: 14.5,
    );

    _kApplePlex = amaps.CameraPosition(
      target: _aMarkerPosition!,
      zoom: 14.5,
    );
  }

  /// Google Maps Marker
  void _gSetMarker(gmaps.LatLng position) {
    setState(() {
      _gMarkers = {
        gmaps.Marker(
          markerId: const gmaps.MarkerId('selected_location'),
          position: position,
          draggable: true,
          onDragEnd: (newPos) {
            _gMarkerPosition = newPos;
            _gSetMarker(newPos);
          },
        ),
      };
    });
  }

  /// Apple Maps Annotation
  void _aSetMarker(amaps.LatLng position) {
    setState(() {
      _aMarkerPosition = position;
      _aAnnotations = {
        amaps.Annotation(
          annotationId:  amaps.AnnotationId('my_marker'),
          position: position,
          draggable: true,
          onDragEnd: (newPos) {
            _aMarkerPosition = newPos;
            _aSetMarker(newPos);
          },
        ),
      };
    });
  }

  void _onGoogleMapTapped(gmaps.LatLng position) {
    _gMarkerPosition = position;
    _gSetMarker(position);
  }

  void _onAppleMapTapped(amaps.LatLng position) {
    _aMarkerPosition = position;
    _aSetMarker(position);
  }

  void _onAppleMapCreated(amaps.AppleMapController controller) {
    _appleMapController = controller;
  }

  Future<void> _moveToCurrentLocation() async {
    LocationData loc = await _location.getLocation();
    final gPos = gmaps.LatLng(loc.latitude!, loc.longitude!);
    final aPos = amaps.LatLng(loc.latitude!, loc.longitude!);

    if (Platform.isAndroid) {
      final controller = await _googleController.future;
      controller.animateCamera(gmaps.CameraUpdate.newLatLng(gPos));
      _gSetMarker(gPos);
    } else if (Platform.isIOS) {
      _appleMapController?.moveCamera(
        amaps.CameraUpdate.newCameraPosition(
          amaps.CameraPosition(
            target: aPos,
            zoom: 17,
            pitch: 30,
            heading: 0,
          ),
        ),
      );
      _aSetMarker(aPos);
    }
  }

  void _sendLocation(String receiverId) {
    if (_gMarkerPosition != null) {
      final latitude = Platform.isAndroid
          ? _gMarkerPosition!.latitude
          : _aMarkerPosition!.latitude;
      final longitude = Platform.isAndroid
          ? _gMarkerPosition!.longitude
          : _aMarkerPosition!.longitude;

      final appleMapsUrl = 'maps://?q=$latitude,$longitude';
      final googleMapsUrl = 'https://www.google.com/maps?q=$latitude,$longitude';

      MessageService()
          .sendMessage(
        Platform.isAndroid ? googleMapsUrl : appleMapsUrl,
        Authenticator().user!.uid,
        receiverId,
      )
          .then((_) => context.pop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Platform.isAndroid
          ? gmaps.GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: _gMarkers,
        onMapCreated: (controller) => _googleController.complete(controller),
        onTap: _onGoogleMapTapped,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      )
          : amaps.AppleMap(
        initialCameraPosition: _kApplePlex,
        mapType: amaps.MapType.hybrid,
        onMapCreated: _onAppleMapCreated,
        onTap: _onAppleMapTapped,
        annotations: _aAnnotations ?? {},
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            onPressed: _moveToCurrentLocation,
            label: const Text('Get Current Location'),
            icon: const Icon(Icons.my_location),
          ),
          FloatingActionButton.extended(
            onPressed: () => _sendLocation(widget.receiverId),
            label: const Text('Send Location'),
            icon: const Icon(Icons.location_on),
          ),
        ],
      ),
    );
  }
}
