import 'package:file_picker/file_picker.dart';

Future<void>pickDocumentFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf', 'doc', 'docx', 'txt'], // you can add more
  );

  if (result != null && result.files.single.path != null) {
    String path = result.files.single.path!;
    print("Selected document path: $path");
  } else {
    print("No document selected");
  }
}
