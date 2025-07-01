import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/image_picker/image_camera_picker.dart';

Future<void> showImageSourceDialog(BuildContext context) async {
  final _picker=Picker();
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Change Image'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: (){
             _picker.cameraPicker();
            }
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
              onTap: (){
                _picker.galleryPicker();
              }
          ),
        ],
      ),
    ),
  );
}
