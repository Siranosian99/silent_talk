import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:silent_talk/core/utils/file_picker/documents.dart';
import 'package:silent_talk/features/chat/services/send_messages.dart';

import '../../../features/chat/widgets/send_file_dialog.dart';
import '../../../features/auth/services/authenticator.dart';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
// Future<void> pickDocumentFile(BuildContext context, String receiverId) async {
//   FilePickerResult? result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['pdf', 'doc', 'docx', 'txt'], // you can add more
//   );
//
//   if (result != null && result.files.single.path != null) {
//     String path = result.files.single.path!;
//     final fileName = result.names[0]!;
//     print("before----------------------$path");
//     print("before----------------------$fileName");
//
//     if(!context.mounted) return;
//     showFileDialog(context, result.names[0].toString(), () async {
//       print("----------------------inside code");
//       String fileUrl= await DocumentsUtilty().uploadDocuments(path, fileName) ?? '';
//       print("--------------$fileUrl");
//       MessageService().sendMessage(
//         fileUrl!,
//         Authenticator().user!.uid,
//         receiverId,
//       );
//       print("after------------------------------------------${result.names[0]}");
//       print("after-------------------------------Selected document path: $path");
//     });
//   } else {
//     print("No document selected or There is Another error");
//   }
// }

// Future<String> readFileContent(String path) async {
//   final file = File(path);
//   final content = await file.readAsString();
//   return content;
//   print('Text content: $content');
//   // now send this content to your chat
// }
//Future<void> pickDocumentFile(BuildContext context, String receiverId) async {
//   final result = await FilePicker.platform.pickFiles(
//     type: FileType.custom,
//     allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
//   );
//
//   if (result != null && result.files.single.path != null) {
//     final path = result.files.single.path!;
//     final fileName = result.names[0]!;
//
//     print("📄 Selected document: $fileName");
//     print("📂 Path: $path");
//
//     // Show a preview or confirmation dialog
//     showFileDialog(context, fileName, () async {
//       // ✅ 1. Upload to Supabase first
//       final uploader = DocumentUploader();
//       final fileUrl = await uploader.uploadDocument(path, fileName);
//
//       if (fileUrl != null) {
//         // ✅ 2. Send message with Supabase URL to Firebase
//         await MessageService().sendMessage(
//           fileUrl, // send Supabase file URL, not local path
//           Authenticator().user!.uid,
//           receiverId,
//         );
//
//         print("✅ Message sent with document: $fileUrl");
//       } else {
//         print("❌ Upload failed — message not sent.");
//       }
//     });
//   } else {
//     print("⚠️ No document selected");
//   }
// }
class FileHelper{
  Future<String?> pickTheFile()async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'doc', 'docx']    );
    final String? resultFile=result?.files.single.path;
    if(resultFile == null){
      return null;
    }
      print("--this is result of File:$resultFile");
    await StorageService().uploadFile(resultFile);
      return resultFile;
  }
}


class StorageService {
  final supabase = Supabase.instance.client;

  Future<String?> uploadFile(String filePath) async {
    try {
      final file = File(filePath);

      if (await file.exists()) {
        return null;
      }

      final fileName = file.path.split('/').last;

      final uniqueName =
          '${DateTime.now().millisecondsSinceEpoch}_$fileName';


      await supabase.storage
          .from('documents')
          .upload(uniqueName, file);


      final publicUrl = supabase.storage
          .from('documents')
          .getPublicUrl(uniqueName);
      print('uploadeddd');
      return publicUrl;
    } catch (e) {
      print('Upload Error: $e');
      return null;
    }
  }
}