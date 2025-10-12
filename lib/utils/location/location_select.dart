import 'package:location/location.dart';
class LocationUtilty{
  Location location = Location();
  bool? serviceEnabled;
  PermissionStatus? permissionGranted;
  LocationData? locationData;
Future<void> getLocation()async{
  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled!) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled!) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  locationData = await location.getLocation();
  print(locationData.toString());
}
}