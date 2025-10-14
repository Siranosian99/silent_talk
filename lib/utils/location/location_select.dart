import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';

import '../../service/authenticator/authenticator.dart';
import '../../service/messages/send_messages.dart';

Future<void> sendLocation(String receiverId, BuildContext context) async {
  Location location = Location();
location.getLocation();
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

  LocationData loc = await location.getLocation();

  final double? latitude = loc.latitude;
  final double? longitude = loc.longitude;

  if (latitude != null && longitude != null) {
    final googleMapsUrl = "https://www.google.com/maps?q=$latitude,$longitude";

    await context.pushNamed(
      'mapLayer',
      extra: {
        "latitude": latitude,
        "longitude": longitude,
        "receiverId": receiverId,
      },
    );

    print("📍 Location sent: $googleMapsUrl");
  }
}
