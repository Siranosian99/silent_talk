import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void showCustomBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 24,
        runSpacing: 24,
        children: [
          _buildOption(Icons.photo, 'Photo',(){}),
          _buildOption(Icons.camera_alt, 'Camera',(){}),
          _buildOption(Icons.location_on, 'Location',(){}),
          _buildOption(Icons.contacts, 'Contact',(){}),
          _buildOption(Icons.insert_drive_file, 'Document',(){}),
          _buildOption(Icons.event, 'Event',(){}),
          _buildOption(Icons.poll, 'Poll',(){}),
          _buildOption(FontAwesomeIcons.spotify, 'Spotify',(){}),
          _buildOption(Icons.share, 'Share',(){}),
        ],
      ),
    ),
  );
}

Widget _buildOption(IconData icon, String label,VoidCallback onTap) {
  return InkWell(
    onTap: (){},
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey[200],
          child: Icon(icon, size: 28, color: Colors.black87),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    ),
  );
}
