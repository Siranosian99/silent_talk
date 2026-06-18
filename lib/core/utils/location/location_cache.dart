import 'package:hive/hive.dart';

class LocationCache {
  static final box = Hive.box('location_cache');
  //saving location lastest route
  static Future<void> save(double lat, double lng) async {
    await box.put('lat', lat);
    await box.put('lng', lng);
  }

  static double? getLat() => box.get('lat');
  static double? getLng() => box.get('lng');
}