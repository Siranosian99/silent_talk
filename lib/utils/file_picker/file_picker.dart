import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:silent_talk/service/messages/send_messages.dart';
import 'package:silent_talk/utils/file_picker/documents.dart';

import '../../service/authenticator/authenticator.dart';
import '../../widgets/send_file_dialog.dart';

Future<void> pickDocumentFile(BuildContext context, String receiverId) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc', 'docx', 'txt'], // you can add more
  );

  if (result != null && result.files.single.path != null) {
    String path = result.files.single.path!;
    final fileName = result.names[0]!;

    showFileDialog(context, result.names[0].toString(), () async {
      String? fileUrl= await DocumentsUtilty().uploadDocuments(path, fileName);
      MessageService().sendMessage(
        fileUrl!,
        Authenticator().user!.uid,
        receiverId,
      );
      // print(result.names[0]);
      // print("Selected document path: $path");
    });
  } else {
    print("No document selected or There is Another error");
  }
}

Future<String> readFileContent(String path) async {
  final file = File(path);
  final content = await file.readAsString();
  return content;
  print('Text content: $content');
  // now send this content to your chat
}
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