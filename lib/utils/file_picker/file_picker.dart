import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:silent_talk/service/messages/send_messages.dart';

import '../../service/authenticator/authenticator.dart';
import '../../widgets/send_file_dialog.dart';

Future<void> pickDocumentFile(BuildContext context, String receiverId) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc', 'docx', 'txt'], // you can add more
  );

  if (result != null && result.files.single.path != null) {
    String path = result.files.single.path!;
    print(result.names[0]);
    print("Selected document path: $path");
    showFileDialog(context, result.names[0].toString(), () {
      MessageService().sendMessage(
        path,
        Authenticator().user!.uid,
        receiverId,
      );
    });
  } else {
    print("No document selected");
  }
}

Future<String> readFileContent(String path) async {
  final file = File(path);
  final content = await file.readAsString();
  return content;
  print('Text content: $content');
  // now send this content to your chat
}
