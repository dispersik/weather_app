import 'package:geocoder/geocoder.dart';

Future<dynamic> getAddressFromCoordinates(double latitude, double longitude) {
  return Geocoder.local.findAddressesFromCoordinates(Coordinates(latitude, longitude));
}