import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../service/authenticator/authenticator.dart';
import '../utils/image_picker/image_picker.dart';

Future<void> showImageSourceDialog(BuildContext context,String image,bool isPressed) async {
  final picker = Provider.of<Picker>(context, listen: false);
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
            onTap: () {
              picker.cameraPicker();
              Navigator.pop(context);
            }
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
              onTap: ()async{
                picker.galleryPicker();
                Navigator.pop(context);

              await Authenticator().updateProilePhoto(image);}
          ),
        ],
      ),
    ),
  );
}
