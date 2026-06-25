import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  Future<bool> cameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return status.isGranted;
    } catch (_) {
      return false;
    }
  }

  Future<bool> galleryPermission() async {
    try {
      final status = await Permission.photos.request();
      return status.isGranted;
    } catch (_) {
      return false;
    }
  }



  Future<bool> locationPermission() async {
    try {
      final status = await Permission.location.request();
      return status.isGranted;
    } catch (_) {
      return false;
    }
  }
}
