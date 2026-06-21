import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:silent_talk/core/utils/file_picker/documents.dart';
import 'package:silent_talk/features/chat/services/send_messages.dart';

import '../../../features/chat/widgets/send_file_dialog.dart';
import '../../../features/auth/services/authenticator.dart';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';



Future<String> readFileContent(String path) async {
  final file = File(path);
  final content = await file.readAsString();
  return content;
}

class FileHelper {
  final storageService=StorageService();
  final messageService=MessageService();
  Future<String?> pickTheFile(BuildContext context, String senderId,String reciverId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'doc', 'docx'],
    );
    final String? resultFile = result?.files.single.path;
    // final String? fileName = result?.files.single.name ;

    if (resultFile == null) {
      return null;
    }
    if (!context.mounted) {
      return null;
    }

    final fileUrl = await storageService.uploadFile(resultFile);
    final fileName = Uri.decodeComponent(
      Uri.parse(fileUrl!).pathSegments.last,
    );
    print('This is File URL:$fileUrl');
    if (!context.mounted) {
      return null;
    }
    await showFileDialog(
      context,fileName,
          () async {
        await messageService.sendMessage(
          fileUrl,
          senderId,
          reciverId,
          "document"
        );
      },
    );
    return resultFile;
  }
}

class StorageService {
  final supabase = Supabase.instance.client;

  Future<String?> uploadFile(String filePath) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        return null;
      }

      final fileName = file.path
          .split('/')
          .last;

      final uniqueName = '${DateTime
          .now()
          .millisecondsSinceEpoch}_$fileName';

      await supabase.storage.from('documents').upload(uniqueName, file);

      final publicUrl = supabase.storage
          .from('documents')
          .getPublicUrl(uniqueName);

      print('---------------upload complete');
      return publicUrl;
    } catch (e) {
      print('Upload Error: $e');
      return null;
    }
  }
}
