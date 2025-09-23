import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../constants/texts.dart';
import '../service/authenticator/authenticator.dart';
import '../utils/image_picker/image_picker.dart';

Future<void> showImageSourceDialog(BuildContext context) async {
  final picker = Provider.of<Picker>(context, listen: false);
  showDialog(
    barrierDismissible: true,
    context: context,
    builder:
        (context) => AlertDialog(
          title:  Text(AppTexts.instance.chaneImg),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title:  Text(AppTexts.instance.camera),
                onTap: () async {
                  final result =await picker.cameraPicker();
                  if (result != null) {
                    await Authenticator().updateProilePhoto(result);
                    Navigator.pop(context);
                  }

                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title:  Text(AppTexts.instance.gallery),
                onTap: () async {
                  final result = await picker.galleryPicker();
                  if (result != null) {
                    await Authenticator().updateProilePhoto(result);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
  );
}
