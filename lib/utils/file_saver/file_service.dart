import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileSaver {
  /// Get the app's documents directory (internal storage)
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // static Future<void> requestStoragePermission() async {
  //   // Check the current permission status
  //   PermissionStatus status = await Permission.storage.status;
  //
  //   if (status.isGranted) {
  //     print("✅ Storage permission already granted");
  //   } else {
  //     // Request permission
  //     status = await Permission.storage.request();
  //
  //     if (status.isGranted) {
  //       print("✅ Storage permission granted");
  //     } else if (status.isPermanentlyDenied) {
  //       print("❌ Storage permission permanently denied. Open settings to enable it.");
  //       // Optional: open app settings
  //       await openAppSettings();
  //     } else {
  //       print("❌ Storage permission denied");
  //     }
  //   }
  // }


  /// Save text file
  static Future<File> saveText(String fileName, String content) async {
    final path = await _localPath;
    final file = File('$path/$fileName.txt');
    return file.writeAsString(content);
  }

  /// Save PDF file (binary)
  static Future<File> savePDF(String fileName, Uint8List bytes) async {
    final path = await _localPath;
    final file = File('$path/$fileName.pdf');
    return file.writeAsBytes(bytes);
  }

  /// Save image file (binary)
  static Future<File> saveImage(String fileName, Uint8List bytes) async {
    final path = await _localPath;
    final file = File('$path/$fileName.png'); // or jpg
    return file.writeAsBytes(bytes);
  }

  /// Read a file (text)
  static Future<String> readText(String fileName) async {
    final path = await _localPath;
    final file = File('$path/$fileName.txt');
    return await file.readAsString();
  }

  /// Check if file exists
  static Future<bool> fileExists(String fileName) async {
    final path = await _localPath;
    final file = File('$path/$fileName');
    return file.exists();
  }

  /// Get full path of a saved file
  static Future<String> getFilePath(String fileName) async {
    final path = await _localPath;
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

      final file = File('${directory.path}/$fileName');
      return file.writeAsBytes(bytes);
    }
    return null;
  }
}
