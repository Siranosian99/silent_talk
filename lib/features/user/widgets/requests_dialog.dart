import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:silent_talk/features/user/service/user_account.dart';

import '../../../core/utils/image_picker/image_picker.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/services/authenticator.dart';


Future<void> showRequestDialog(BuildContext parentContext) async {
  final picker = Provider.of<Picker>(parentContext, listen: false);
  final UserAccountEdits accountEdit=UserAccountEdits();
  showDialog(
    barrierDismissible: true,
    context: parentContext,
    builder:

        (dialogContext) => AlertDialog(
      title:  Text(AppLocalizations.of(dialogContext)!.chaneImg),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title:  Text(AppLocalizations.of(dialogContext)!.camera),
            onTap: () async {
              final result =await picker.cameraPicker();
              if (result != null) {
                await accountEdit.updateProilePhoto(result).then((_){
                  picker.clearImage();
                });
                if(!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
              }

            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title:  Text(AppLocalizations.of(dialogContext)!.gallery),
            onTap: () async {
              final path = await picker.galleryPicker();
              final localPath=path;
              final result=await picker.imgUploaderToServer(localPath.toString());

              if (result != null) {
                await accountEdit.updateProilePhoto(result).then((_){
                  picker.clearImage();
                });
                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
              }
            },
          ),
        ],
      ),
    ),
  );
}
