  import 'dart:io';
import 'package:file_saver/file_saver.dart' hide FileSaver;
import 'package:path_provider/path_provider.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';
import '../file_saver/file_service.dart';

  class DocumentsUtilty {
    final supabase = Supabase.instance.client;
    Future<String?> uploadDocuments(String path, String fileName) async {
      final documentfile = File(path);
      final publicUrl =
      supabase.storage.from('documents').getPublicUrl(fileName);
      if (path.isNotEmpty && fileName.isNotEmpty) {
        await supabase.storage.from('documents').upload(
          fileName,
          documentfile,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),

        );
        return publicUrl;
      }
      return null;
    }

    Future<String?> downloadDocument(String fileName) async {
      try {
        // 1️⃣ Download bytes from Supabase
        final response = await supabase.storage.from('documents').download(
            fileName);

        // 2️⃣ Get local path to save file
        final dir = await getApplicationDocumentsDirectory(); // or Downloads folder
        final filePath = '${dir.path}/$fileName';

        // 3️⃣ Save file locally
        final file = File(filePath);
        await file.writeAsBytes(response);

        print('✅ File downloaded to $filePath');
        return filePath; // return local path if needed
      } catch (e) {
        print('❌ Download failed: $e');
        return null;
      }
    }


    Future<void> saveMyFile(File file) async {
      final savedPath = await FileSaver().saveAs(
        name: file.path.split('/').last,
        file: file,
        fileExtension: file.path.split('.').last,
        mimeType: MimeType.other,
      );

      print('✅ File saved at: $savedPath');
    }

  }
  //
  // Future<String?> uploadDocuments(String path, String fileName) async {
  //     try {
  //       final documentFile = File(path);
  //
  //       // Upload the file to your Supabase bucket ('documents')
  //       await supabase.storage.from('documents').upload(
  //         fileName,
  //         documentFile,
  //         fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
  //       );
  //
  //       // Get the public URL
  //       final publicUrl =
  //       supabase.storage.from('documents').getPublicUrl(fileName);
  //
  //       print('✅ File uploaded. Public URL: $publicUrl');
  //       return publicUrl; // ✅ Return the link
  //     } catch (e) {
  //       print('❌ Upload failed: $e');
  //       return null;
  //     }
  //   }