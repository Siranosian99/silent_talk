import 'dart:io';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:file_saver/file_saver.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../features/auth/services/authenticator.dart';

class StorageService {
  final supabase = Supabase.instance.client;
  final authenticator = Authenticator();

  Future<String?> uploadFile(String filePath) async {
    try {
      final file = File(filePath);

      if (!await file.exists()) {
        return null;
      }

      final fileName = file.path.split('/').last;

      final path =
          '${authenticator.user?.uid}/chat_files/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      await supabase.storage.from('documents').upload(path, file);

      final publicUrl = supabase.storage.from('documents').getPublicUrl(path);

      print('---------------upload complete');
      return publicUrl;
    } catch (e) {
      print('Upload Error: $e');
      return null;
    }
  }
  Future<String?> downloadFile(String path)async{
    try{
      final bytes = await supabase.storage
        .from('documents')
        .download(path);
      //changing here the name
      final fileName = path.split('/').last;
      // making clean name here
      final cleanName = fileName.split('_').skip(1).join('_');
      //create the directory inside phone
      final dir = await getApplicationDocumentsDirectory();
      //create the location inside the phone which folder
      final file = File("${dir.path}/$cleanName");
      // here putting the data which comes binary from db
      await file.writeAsBytes(bytes);
      return file.path;
    }
    catch(e){
      print("error in download :( $e");
      return null; // 👈 BU ŞART
    }
  }
  Future <void> openDocument (String path)async{
    final result= await downloadFile(path);
    if(result == null) return;
    OpenFilex.open(result);
  }
}
