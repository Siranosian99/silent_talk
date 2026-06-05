import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../constants/texts.dart';
import '../../../core/utils/image_picker/image_picker.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/services/authenticator.dart';

Future<void> showImageSourceDialog(BuildContext context) async {
  final picker = Provider.of<Picker>(context, listen: false);
  showDialog(
    barrierDismissible: true,
    context: context,
    builder:
        (context) => AlertDialog(
          title:  Text(AppLocalizations.of(context)!.chaneImg),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title:  Text(AppLocalizations.of(context)!.camera),
                onTap: () async {
                  final result =await picker.cameraPicker();
                  if (result != null) {
                    await Authenticator().updateProilePhoto(result).then((_){
                      picker.clearImage();
                    });
                    if(!context.mounted) return;
                    Navigator.pop(context);
                  }

                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title:  Text(AppLocalizations.of(context)!.gallery),
                onTap: () async {
                  final path = await picker.galleryPicker();
                  final localPath=path;
                  final result=await picker.imgUploaderToServer(localPath.toString());

                  if (result != null) {
                    await Authenticator().updateProilePhoto(result).then((_){
                      picker.clearImage();
                    });
                    if(!context.mounted) return;
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
  );
}
