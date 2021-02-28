import 'package:geolocator/geolocator.dart';

Future<Position> geolocatorRoutine() async {
  // firstly check permissions
  try {
    await checkAccessability();
  } catch (e) {
    return Future.error(e);
  }

  // if ok, trying to obtain current position
  var position;
  try {
    position = await getCurrentLocationBrute();
  } catch (e) {
    print('error in bloc: $e');
    return Future.error(e);
  }
  return position;
}

Future<Position> getCurrentLocationBrute() async {
  var result;

  for (var accuracy in LocationAccuracy.values.reversed) {
    try {
      print('brute get location: $accuracy');
      result = await Geolocator.getCurrentPosition(
          desiredAccuracy: accuracy,
          timeLimit: Duration(seconds: 5),
          forceAndroidLocationManager: false);
    } catch (e) {
      print(e);
      continue;
    }
    break;
  }
  return result ?? Future.error('Failed to get current location');
}

Future<void> checkAccessability() async {
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
          'Location permissions are denied.');
    }
  }
  print('Location permissions are ok');
}
