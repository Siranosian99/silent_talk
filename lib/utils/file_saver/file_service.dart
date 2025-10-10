import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileSaver {
  /// Get the app's documents directory (internal storage)
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  static Future<Directory> getAppDownloadFolder() async {
    // 1️⃣ Request storage permission (Android 13+ may need extra handling)
    if (await Permission.storage.request().isGranted) {
      // 2️⃣ Get the base Download folder
      Directory downloadDir = Directory('/storage/emulated/0/Download');

      // 3️⃣ Create a subfolder for your app
      Directory appFolder = Directory('${downloadDir.path}/SilentTalk');

      // 4️⃣ Create the folder if it doesn't exist
      if (!(await appFolder.exists())) {
        await appFolder.create(recursive: true);
      }

      print("✅ Folder path: ${appFolder.path}");
      return appFolder;
    } else {
      throw Exception("Storage permission not granted!");
    }
  }

  static Future<void> requestStoragePermission() async {
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      print("✅ Storage permission granted");
    } else {
      print("❌ Storage permission denied");
    }
  }


  /// Save text file
  static Future<File> saveText(String fileName, String content) async {
    final path = await _localPath;
    Directory folder = await getAppDownloadFolder();
    final file = File('$path/$fileName.txt');
    print("✅ File saved at: ${file.path}");
    return file.writeAsString(content);
  }

  /// Save PDF file (binary)
  static Future<File> savePDF(String fileName, Uint8List bytes) async {
    final path = await _localPath;
    Directory folder = await getAppDownloadFolder();
    final file = File('$path/$fileName.pdf');
    return file.writeAsBytes(bytes);
  }

  /// Save image file (binary)
  static Future<File> saveImage(String fileName, Uint8List bytes) async {
    final path = await _localPath;
    Directory folder = await getAppDownloadFolder();
    final file = File('$path/$fileName.png'); // or jpg
    return file.writeAsBytes(bytes);
  }

  /// Read a file (text)
  static Future<String> readText(String fileName) async {
    final path = await _localPath;
    Directory folder = await getAppDownloadFolder();
    final file = File('$path/$fileName.txt');
    return await file.readAsString();
  }

  /// Check if file exists
  static Future<bool> fileExists(String fileName) async {
    final path = await _localPath;
    Directory folder = await getAppDownloadFolder();
    final file = File('$path/$fileName');
    return file.exists();
  }

  /// Get full path of a saved file
  static Future<String> getFilePath(String fileName) async {
    final path = await _localPath;
    Directory folder = await getAppDownloadFolder();
    return '$path/$fileName';
  }

  /// (Optional) Save to external storage on Android
  static Future<File?> saveToExternal(String fileName, Uint8List bytes) async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) return null;

      final directory = Directory('/storage/emulated/0/Download'); // or any folder
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final file = File('${directory.path}/$fileName.jpg}');
      print("✅ File saved at: ${file.path}");
      return file.writeAsBytes(bytes);
    }
    return null;
  }

  static Future<void> downloadAndSave(String url, String fileName) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes; // actual file bytes
        await FileSaver.saveToExternal(fileName, bytes);
        print("✅ File saved: $fileName");
      } else {
        print("❌ Failed to download file: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error downloading file: $e");
    }
  }
}
