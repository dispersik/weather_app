import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

const String apiKey = '603887f8f6f98b5e4c24fd9877a40061';

Future<http.Response> getCurrentForecastByCoordinates(Position position,
    [String apiKey = apiKey]) async {
  var apiLocation = 'http://api.openweathermap.org/data/2.5/';
  var apiQuery =
      'forecast?lat=${position.latitude}&lon=${position.longitude}&APPID=$apiKey';
  var uri = apiLocation + apiQuery;
  var result;
  try {
    result = http.get(uri);
  } catch (e) {
    print(e);
    rethrow;
  }
  return result;
}

String addressToLocation(Address address) {
  if (address.countryName != null && address.locality != null) {
    return '${address.locality},${address.countryName}';
  } else {
    return null;
  }
}
