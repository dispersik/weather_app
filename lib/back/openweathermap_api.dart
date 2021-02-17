import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;

String apiKey = '603887f8f6f98b5e4c24fd9877a40061';

Future<http.Response> getCurrentWeather(String location, String apiKey) async {
  var apiLocation = 'http://api.openweathermap.org/data/2.5/';
  var apiQuery = 'weather?q=$location&APPID=$apiKey';
  var uri = apiLocation+apiQuery;

  return http.get(uri);
}

String addressToLocation(Address address) {
  if (address.countryName!=null && address.locality!=null) {
    return '${address.locality},${address.countryName}';
  } else {
    return null;
  }
}