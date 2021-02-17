import 'package:geolocator/geolocator.dart';

Future<Position> getCurrentLocation() async {
  return Geolocator.getCurrentPosition();
}