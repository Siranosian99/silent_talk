import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../service/authenticator/authenticator.dart';
import '../../service/messages/send_messages.dart';

class MapSample extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String receiverId;

  const MapSample({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.receiverId,
  });

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late final Location _location;
  Set<Marker> _markers = {};
  late CameraPosition _kGooglePlex;
  LatLng? _markerPosition;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    _location = Location();
    _markerPosition = LatLng(widget.latitude, widget.longitude);
    _setMarker(_markerPosition!);
    _kGooglePlex = CameraPosition(
      target: _markerPosition!,
      zoom: 14.4746,
    );
  }

  void _setMarker(LatLng position) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected_location'),
          position: position,
          draggable: true,
          onDragEnd: (newPosition) {
            _markerPosition = newPosition;
            _setMarker(newPosition); // Update marker after drag
          },
        ),
      };
    });
  }

  void _onMapTapped(LatLng position) {
    _markerPosition = position;
    _setMarker(position); // Update marker on map tap
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: _markers,
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (controller) => _controller.complete(controller),
        onTap: _onMapTapped,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              LocationData loc = await _location.getLocation();
              LatLng newPos = LatLng(loc.latitude!, loc.longitude!);
              final controller = await _controller.future;
              controller.animateCamera(CameraUpdate.newLatLng(newPos));
              _setMarker(newPos);
            },
            label: const Text('Get Current Location!'),
            icon: const Icon(Icons.my_location_outlined),
          ),
          FloatingActionButton.extended(
            onPressed: () {
              _sendLocation(widget.receiverId);
            },
            label: const Text('Send Location!'),
            icon: const Icon(Icons.location_on_rounded),
          ),
        ],
      ),
    );
  }

  void _sendLocation(String receiverId) {
    if (_markerPosition != null) {
      final googleMapsUrl = "https://www.google.com/maps?q=${_markerPosition!.latitude},${_markerPosition!.longitude}";
      MessageService().sendMessage(
        googleMapsUrl,
        Authenticator().user!.uid,
        receiverId,
      ).then((_) => context.pop());
    }
  }
}
