import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/utils/location/location_select.dart';

import '../utils/file_picker/file_picker.dart';
import '../utils/image_picker/image_picker.dart';
import 'contact_shower_sheet.dart';

void showCustomBottomSheet(
  BuildContext context,
  int index,
  String id, {
  String? fileName,
}) {
  final picker = Provider.of<Picker>(context, listen: false);
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder:
        (context) => Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 24,
            runSpacing: 24,
            children: [
              _buildOption(Icons.photo, 'Photo', () {
                picker.galleryPicker();
                Navigator.pop(context);
              }),
              _buildOption(Icons.camera_alt, 'Camera', () {
                picker.cameraPicker();
                Navigator.pop(context);
              }),
              _buildOption(Icons.location_on, 'Location', () async {
               sendLocation(id, context);
                // context.goNamed('mp');
              }),
              _buildOption(Icons.contacts, 'Contact', () {
                context.pushNamed(
                  'contact',
                  extra: {"id": id, "index": index}, // Passing index here
                );
              }),
              _buildOption(Icons.insert_drive_file, 'Document', () {
                pickDocumentFile(context, id);
              }),
              // _buildOption(Icons.event, 'Event', () {}),
              // _buildOption(Icons.poll, 'Poll', () {}),
              _buildOption(FontAwesomeIcons.spotify, 'Spotify', () {}),
              // _buildOption(Icons.share, 'Share', () {}),
            ],
          ),
        ),
  );
}

Widget _buildOption(IconData icon, String label, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
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
