import 'package:geolocator/geolocator.dart';

// Future<Position> getCurrentLocation() async {
//   var result;
//   try {
//     print('get location');
//     result = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.lowest,
//         timeLimit: Duration(seconds: 20),
//         forceAndroidLocationManager: false);
//   } catch (e) {
//     print(e);
//     return Future.error('Failed to get current location');
//   }
//   return result;
// }

Future<Position> getCurrentLocationBrute() async {
  var result;
  var accuracies = [
    LocationAccuracy.best,
    LocationAccuracy.high,
    LocationAccuracy.medium,
    LocationAccuracy.low,
    LocationAccuracy.lowest,
  ];

  for (var accuracy in accuracies) {
    try {
      print('brute get location');
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
          'Location permissions are denied (actual value: $permission).');
    }
  }
  print('Location permissions are ok');
}
