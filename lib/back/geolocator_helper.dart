import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  try {
    _checkAccessability();
  } catch (e) {
    print(e);
    return Future.error('Failed to get permissions');
  }
  var result;
  try {
    print('get location');
    result = await Geolocator.getCurrentPosition(
        timeLimit: Duration(seconds: 10), forceAndroidLocationManager: true);
  } catch (e) {
    print(e);
    return Future.error('Failed to get current location');
  }
  return result;
}

Future<void> _checkAccessability() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }
  print('Location service working');

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }
  print('Location permissions are ok');
}
