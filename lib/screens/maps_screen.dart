import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMessage extends StatelessWidget {
  final String googleMapsUrl;

  const MapMessage({super.key, required this.googleMapsUrl});

  @override
  Widget build(BuildContext context) {
    final coords = _extractLatLng(googleMapsUrl);
    if (coords == null) {
      return const Text("Invalid location link");
    }

    final lat = coords.$1; // ✅ fixed
    final lng = coords.$2; // ✅ fixed

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 200,
          width: double.infinity,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(lat, lng),
              zoom: 15,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('shared-location'),
                position: LatLng(lat, lng),
              ),
            },
            liteModeEnabled: true, // ✅ lightweight map for chat
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
          ),
        ),
      ),
    );
  }

  /// Extracts latitude and longitude from Google Maps URL
  (double, double)? _extractLatLng(String url) {
    try {
      final uri = Uri.parse(url);
      final query = uri.queryParameters['q'];
      if (query != null) {
        final parts = query.split(',');
        final lat = double.parse(parts[0]);
        final lng = double.parse(parts[1]);
        return (lat, lng);
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}
