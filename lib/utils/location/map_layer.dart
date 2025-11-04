import 'dart:async';
import 'dart:io';
import 'package:apple_maps_flutter/apple_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:apple_maps_flutter/apple_maps_flutter.dart' as amaps;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import '../../service/authenticator/authenticator.dart';
import '../../service/messages/send_messages.dart';

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
  Set<gmaps.Marker> _gmarkers = {};
  Set<Annotation>? _annotations;
  late gmaps.CameraPosition _kGooglePlex;
  late amaps.CameraPosition _kApplePlex;
  gmaps.LatLng? _markerPosition;
  amaps.LatLng? _amarkerPosition;
  amaps.AppleMapController? mapController;
  final Completer<gmaps.GoogleMapController> _controller =
      Completer<gmaps.GoogleMapController>();
  @override
  void initState() {
    super.initState();
    _location = Location();
    _markerPosition = gmaps.LatLng(widget.latitude, widget.longitude);
    _amarkerPosition=amaps.LatLng(widget.latitude, widget.longitude);
    _asetMarker(_amarkerPosition!);
    _gsetMarker(_markerPosition!);
    _kApplePlex = amaps.CameraPosition(
      target: _amarkerPosition!,
      zoom: 14.4746,
    );
    _kGooglePlex = gmaps.CameraPosition(
      target: _markerPosition!,
      zoom: 14.4746,
    );
  }

  void _gsetMarker(gmaps.LatLng position) {
    setState(() {
      _gmarkers = {
        gmaps.Marker(
          markerId: const gmaps.MarkerId('selected_location'),
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

  void _asetMarker(amaps.LatLng position) {
    setState(() {
      _annotations = {
        amaps.Annotation(
          annotationId:  amaps.AnnotationId('my_marker'),
          position: position,
          draggable: true,
          onDragEnd: (newPosition) {
            _amarkerPosition = newPosition;
            _asetMarker(newPosition); // Update marker after drag
          },
          // optional: subtitle, image, etc.
        ),
      };
    });
  }
  void _onAMapTapped(amaps.LatLng position) {
    _amarkerPosition = position;
    _asetMarker(position); // Update marker on map tap
  }
  void _onMapTapped(gmaps.LatLng position) {
    _markerPosition = position;
    _gsetMarker(position); // Update marker on map tap
  }

  ///////IOS
  void _onMapCreated(amaps.AppleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Platform.isAndroid
              ? gmaps.GoogleMap(
                markers: _gmarkers,
                mapType: gmaps.MapType.normal,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (controller) => _controller.complete(controller),
                onTap: _onMapTapped,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              )
              : amaps.AppleMap(
                mapType: amaps.MapType.hybrid,
                onMapCreated: _onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
              onTap: _onAMapTapped,
              annotations :{
                amaps.Annotation(
                  annotationId: amaps.AnnotationId('my_marker'),
                  position: amaps.LatLng(widget.latitude,widget.longitude),
                  draggable: true,
                  onDragEnd: (newPos) {
                    print("New position: ${newPos.latitude}, ${newPos.longitude}");
                  },
                ),
              },
              initialCameraPosition: _kApplePlex

              ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            onPressed: () async {
              LocationData loc = await _location.getLocation();

              gmaps.LatLng gnewPos = gmaps.LatLng(
                loc.latitude!,
                loc.longitude!,
              );

              amaps.LatLng anewPos = amaps.LatLng(
                loc.latitude!,
                loc.longitude!,
              );

              if (Platform.isAndroid) {
                final controller = await _controller.future;
                controller.animateCamera(gmaps.CameraUpdate.newLatLng(gnewPos));
                _gsetMarker(gnewPos);
              } else {
                mapController?.moveCamera(
                  amaps.CameraUpdate.newCameraPosition(
                    amaps.CameraPosition(
                      heading: 270.0,
                      target: anewPos,
                      pitch: 30.0,
                      zoom: 17,
                    ),
                  ),
                );
                _asetMarker(anewPos);
                print(anewPos);
              }
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
      final appleMapsUrl =
          'maps://?q=${_markerPosition!.latitude},${_markerPosition!.longitude}';
      final googleMapsUrl =
          "https://www.google.com/maps?q=${_markerPosition!.latitude},${_markerPosition!.longitude}";
      MessageService()
          .sendMessage(
            Platform.isAndroid ? googleMapsUrl : appleMapsUrl,
            Authenticator().user!.uid,
            receiverId,
          )
          .then((_) => context.pop());
    }
  }
}

// class AppleMapsExample extends StatelessWidget {
//   AppleMapController mapController;
//
//   void _onMapCreated(AppleMapController controller) {
//     mapController = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: <Widget>[
//         Expanded(
//           child: Container(
//             child: AppleMap(
//               onMapCreated: _onMapCreated,
//               initialCameraPosition: const CameraPosition(
//                 target: LatLng(0.0, 0.0),
//               ),
//             ),
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             Column(
//               children: <Widget>[
//                 FlatButton(
//                   onPressed: () {
//                     mapController.moveCamera(
//                       CameraUpdate.newCameraPosition(
//                         const CameraPosition(
//                           heading: 270.0,
//                           target: LatLng(51.5160895, -0.1294527),
//                           pitch: 30.0,
//                           zoom: 17,
//                         ),
//                       ),
//                     );
//                   },
//                   child: const Text('newCameraPosition'),
//                 ),
//                 FlatButton(
//                   onPressed: () {
//                     mapController.moveCamera(
//                       CameraUpdate.newLatLngZoom(
//                         const LatLng(37.4231613, -122.087159),
//                         11.0,
//                       ),
//                     );
//                   },
//                   child: const Text('newLatLngZoom'),
//                 ),
//               ],
//             ),
//             Column(
//               children: <Widget>[
//                 FlatButton(
//                   onPressed: () {
//                     mapController.moveCamera(
//                       CameraUpdate.zoomIn(),
//                     );
//                   },
//                   child: const Text('zoomIn'),
//                 ),
//                 FlatButton(
//                   onPressed: () {
//                     mapController.moveCamera(
//                       CameraUpdate.zoomOut(),
//                     );
//                   },
//                   child: const Text('zoomOut'),
//                 ),
//                 FlatButton(
//                   onPressed: () {
//                     mapController.moveCamera(
//                       CameraUpdate.zoomTo(16.0),
//                     );
//                   },
//                   child: const Text('zoomTo'),
//                 ),
//               ],
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }
