import 'package:flutter/material.dart';

class MapPreview extends StatefulWidget {
  final double width;
  final double height;
  final String url;

  const MapPreview({
    Key? key,
    this.width = 200,
    this.height = 150,
    required this.url,
  }) : super(key: key);

  @override
  State<MapPreview> createState() => _MapPreviewState();
}

class _MapPreviewState extends State<MapPreview> {
  String? latitude;
  String? longitude;

  @override
  void initState() {
    super.initState();
    _extractCoordinates();
  }

  void _extractCoordinates() {
    try {
      final coords = widget.url.split("q=").last;
      final parts = coords.split(",");
      latitude = parts[0].trim();
      longitude = parts[1].trim();
    } catch (e) {
      latitude = null;
      longitude = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (latitude == null || longitude == null) {
      return  Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Invalid map URL',
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    final staticMapUrl =
        'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=14&size=${widget.width.toInt()}x${widget.height.toInt()}&markers=color:red%7C$latitude,$longitude&key=AIzaSyA7Hi82BXzseAJZAlfLgxE5VGYCs-rV924';

    return  ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        staticMapUrl,
        width: widget.width,
        height: widget.height,
        fit: BoxFit.cover,
      ),
    );
  }
}
