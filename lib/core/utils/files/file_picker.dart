import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:silent_talk/features/chat/services/send_messages.dart';

import '../../../features/chat/widgets/send_file_dialog.dart';
import '../../../features/auth/services/authenticator.dart';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'documents.dart';
import 'link_parse.dart';

class FileHelper {
  final storageService = StorageService();
  final messageService = MessageService();

  Future<String?> pickTheFile(
    BuildContext context,
    String senderId,
    String receiverId,
  ) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'doc', 'docx'],
    );
    final String? resultFile = result?.files.single.path;
    // final String? fileName = result?.files.single.name ;
    if (resultFile == null || !context.mounted) return null;
    final finalFileName = resultFile.split('/').last;

    await showFileDialog(context, finalFileName, () async {
      final fileUrl = await storageService.uploadFile(resultFile);
      if (fileUrl == null) return;
      await messageService.sendMessage(
        extractPath(fileUrl),
        senderId,
        receiverId,
        "document",
      );
    });

    if (!context.mounted) {
      return null;
    }

    return resultFile;
  }


}
