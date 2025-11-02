// import 'dart:async';
// import 'dart:io';
// import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
// import 'package:apple_maps_flutter/apple_maps_flutter.dart' as amaps;
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:location/location.dart';
// import '../../service/authenticator/authenticator.dart';
// import '../../service/messages/send_messages.dart';
//
// class MapSample extends StatefulWidget {
//   final String receiverId;
//   final double latitude;
//   final double longitude;
//
//   const MapSample({
//     super.key,
//     required this.receiverId,
//     required this.latitude,
//     required this.longitude,
//   });
//
//   @override
//   State<MapSample> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<MapSample> {
//   late final Location _location;
//   Set<gmaps.Marker> _markers = {};
//   late gmaps.CameraPosition _kGooglePlex;
//   gmaps.LatLng? _markerPosition;
//   amaps.AppleMapController? mapController;
//   final Completer<gmaps.GoogleMapController> _controller =
//       Completer<gmaps.GoogleMapController>();
//
//   @override
//   void initState() {
//     super.initState();
//     _location = Location();
//     _markerPosition = gmaps.LatLng(widget.latitude, widget.longitude);
//     _setMarker(_markerPosition!);
//     _kGooglePlex = gmaps.CameraPosition(
//       target: _markerPosition!,
//       zoom: 14.4746,
//     );
//   }
//
//   Future<bool?> requestPermissions() async {
//     bool serviceEnabled = await _location.serviceEnabled();
//     if (!serviceEnabled) {
//       serviceEnabled = await _location.requestService();
//       if (!serviceEnabled) {
//         return null;
//       }
//     }
//
//     PermissionStatus permissionGranted = await _location.hasPermission();
//     if (permissionGranted == PermissionStatus.denied) {
//       permissionGranted = await _location.requestPermission();
//       if (permissionGranted != PermissionStatus.granted) return null;
//     }
//     return true;
//   }
//
//   void _setMarker(gmaps.LatLng position) {
//     setState(() {
//       _markers = {
//         gmaps.Marker(
//           markerId: const gmaps.MarkerId('selected_location'),
//           position: position,
//           draggable: true,
//           onDragEnd: (newPosition) {
//             _markerPosition = newPosition;
//             _setMarker(newPosition); // Update marker after drag
//           },
//         ),
//       };
//     });
//   }
//
//   void _onMapTapped(gmaps.LatLng position) {
//     _markerPosition = position;
//     _setMarker(position); // Update marker on map tap
//   }
//
//   ///////IOS
//   void _onMapCreated(amaps.AppleMapController controller) {
//     mapController = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body:
//           Platform.isAndroid
//               ? gmaps.GoogleMap(
//                 markers: _markers,
//                 mapType: gmaps.MapType.normal,
//                 initialCameraPosition: _kGooglePlex,
//                 onMapCreated: (controller) => _controller.complete(controller),
//                 onTap: _onMapTapped,
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: true,
//               )
//               : amaps.AppleMap(
//                 onMapCreated: _onMapCreated,
//                 initialCameraPosition: const amaps.CameraPosition(
//                   target: amaps.LatLng(40.0691, 45.0382),
//                 ),
//               ),
//
//       floatingActionButton: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           FloatingActionButton.extended(
//             onPressed: () async {
//               LocationData loc = await _location.getLocation();
//               gmaps.LatLng newPos = gmaps.LatLng(loc.latitude!, loc.longitude!);
//               final controller = await _controller.future;
//               controller.animateCamera(gmaps.CameraUpdate.newLatLng(newPos));
//               _setMarker(newPos);
//             },
//             label: const Text('Get Current Location!'),
//             icon: const Icon(Icons.my_location_outlined),
//           ),
//           FloatingActionButton.extended(
//             onPressed: () {
//               _sendLocation(widget.receiverId);
//             },
//             label: const Text('Send Location!'),
//             icon: const Icon(Icons.location_on_rounded),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _sendLocation(String receiverId) {
//     if (_markerPosition != null) {
//       final appleMapsUrl =
//           'maps://?q=${_markerPosition!.latitude},${_markerPosition!.longitude}';
//       final googleMapsUrl =
//           "https://www.google.com/maps?q=${_markerPosition!.latitude},${_markerPosition!.longitude}";
//       MessageService()
//           .sendMessage(
//             Platform.isAndroid ? googleMapsUrl : appleMapsUrl,
//             Authenticator().user!.uid,
//             receiverId,
//           )
//           .then((_) => context.pop());
//     }
//   }
// }
//
// // class AppleMapsExample extends StatelessWidget {
// //   AppleMapController mapController;
// //
// //   void _onMapCreated(AppleMapController controller) {
// //     mapController = controller;
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //       crossAxisAlignment: CrossAxisAlignment.stretch,
// //       children: <Widget>[
// //         Expanded(
// //           child: Container(
// //             child: AppleMap(
// //               onMapCreated: _onMapCreated,
// //               initialCameraPosition: const CameraPosition(
// //                 target: LatLng(0.0, 0.0),
// //               ),
// //             ),
// //           ),
// //         ),
// //         Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //           children: <Widget>[
// //             Column(
// //               children: <Widget>[
// //                 FlatButton(
// //                   onPressed: () {
// //                     mapController.moveCamera(
// //                       CameraUpdate.newCameraPosition(
// //                         const CameraPosition(
// //                           heading: 270.0,
// //                           target: LatLng(51.5160895, -0.1294527),
// //                           pitch: 30.0,
// //                           zoom: 17,
// //                         ),
// //                       ),
// //                     );
// //                   },
// //                   child: const Text('newCameraPosition'),
// //                 ),
// //                 FlatButton(
// //                   onPressed: () {
// //                     mapController.moveCamera(
// //                       CameraUpdate.newLatLngZoom(
// //                         const LatLng(37.4231613, -122.087159),
// //                         11.0,
// //                       ),
// //                     );
// //                   },
// //                   child: const Text('newLatLngZoom'),
// //                 ),
// //               ],
// //             ),
// //             Column(
// //               children: <Widget>[
// //                 FlatButton(
// //                   onPressed: () {
// //                     mapController.moveCamera(
// //                       CameraUpdate.zoomIn(),
// //                     );
// //                   },
// //                   child: const Text('zoomIn'),
// //                 ),
// //                 FlatButton(
// //                   onPressed: () {
// //                     mapController.moveCamera(
// //                       CameraUpdate.zoomOut(),
// //                     );
// //                   },
// //                   child: const Text('zoomOut'),
// //                 ),
// //                 FlatButton(
// //                   onPressed: () {
// //                     mapController.moveCamera(
// //                       CameraUpdate.zoomTo(16.0),
// //                     );
// //                   },
// //                   child: const Text('zoomTo'),
// //                 ),
// //               ],
// //             ),
// //           ],
// //         )
// //       ],
// //     );
// //   }
// // }
