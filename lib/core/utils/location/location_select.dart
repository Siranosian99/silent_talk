import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';

import 'location_cache.dart';

Future<void> openMap(String receiverId, BuildContext context) async {


  double? lat = LocationCache.getLat();
  double? lng = LocationCache.getLng();
    if(!context.mounted) return;
    await context.pushNamed(
      'mapLayer',
      extra: {
        "latitude": lat ?? 0,
        "longitude": lng ?? 0,
        "receiverId": receiverId,
      },
    );

}

//First, we get the current user's location and convert it into latitude and longitude coordinates. Then we get the destination coordinates from another user, backend, or message. We send both coordinates to the Google Directions API (or Routes API). The API calculates the route and returns an encoded polyline. We decode that polyline into a list of LatLng points and draw those points on the map using a Polyline widget.
//
// Flow:
//
// Current User Location
//         ↓
//      LatLng
//
// Destination Location
//         ↓
//      LatLng
//
//         ↓
//  Google Directions API
//
//         ↓
//  Encoded Polyline
//
//         ↓
//  Decode Polyline
//
//         ↓
//  List<LatLng>
//
//         ↓
//  Polyline
//
//         ↓
//  Route shown on map