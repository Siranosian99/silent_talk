import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

class DeviceIdHelper {
  static const _boxName = 'device_id';
  static const _key = 'device_id';

  final Box box = Hive.box(_boxName);

  // Get the device ID, generate and save if it doesn't exist
  Future<String> getDeviceId() async {
    String? deviceId = box.get(_key);

    if (deviceId == null) {
      deviceId = const Uuid().v4(); // generate new unique ID
      await box.put(_key, deviceId);
    }

    print('Device ID is ---------------: $deviceId'); // for debugging
    return deviceId;
  }
}
