import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';

Future<void> sendLocation(String receiverId, BuildContext context) async {
  final location = Location();

  bool serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) return;
  }

  PermissionStatus permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) return;
  }

  // ✅ Step 3: Now safely get the current location
  LocationData loc = await location.getLocation();

  final double? latitude = loc.latitude;
  final double? longitude = loc.longitude;

  if (latitude != null && longitude != null) {
    if(!context.mounted) return;
    await context.pushNamed(
      'mapLayer',
      extra: {
        "latitude": latitude,
        "longitude": longitude,
        "receiverId": receiverId,
      },
    );
    print("📍 Location sent: $latitude,$longitude");
    print('maps://?q=$latitude,$longitude');
  }
}
