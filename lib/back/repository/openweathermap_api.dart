import 'dart:convert';

import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/back/weather.dart';

class OpenWeatherMapAPI extends WeatherAPI {
  
  static const String _apiKey = '603887f8f6f98b5e4c24fd9877a40061';
  static const String _apiLocation = 'http://api.openweathermap.org/data/2.5/';
  
  @override
  Future<List<Weather>> getForecastByCoordinates(Position position) async {
    var response;
    try {
      response = await _getCurrentForecastByCoordinates(position);
    } catch (e) {
      print(e);
      rethrow;
    }
    return _responseToWeatherList(response);
  }

  static Future<http.Response> _getCurrentForecastByCoordinates(
      Position position,
      [String apiKey = _apiKey]) async {
    var apiQuery =
        'forecast?lat=${position.latitude}&lon=${position.longitude}&APPID=$apiKey';
    var uri = _apiLocation + apiQuery;
    var result;
    try {
      result = http.get(uri);
    } catch (e) {
      print(e);
      rethrow;
    }
    return result;
  }

  List<Weather> _responseToWeatherList(http.Response response) {
    final List<Weather> weatherList = List<Weather>();
    var decodedResponse = jsonDecode(response.body);
    List<dynamic> list = decodedResponse['list'];
    String city = decodedResponse['city']['name'];
    list.forEach((element) {
      weatherList.add(Weather.fromMap(element, city));
    });
    return weatherList;
  }
  
  Future<bool> pingAPI() {
    try {
      http.get(_apiLocation+'weather?q=London,uk&appid=$_apiKey');
    } catch(e) {
      print(e);
      return Future.value(false);
    }
    return Future.value(true);
  }
}

String addressToLocation(Address address) {
  if (address.countryName != null && address.locality != null) {
    return '${address.locality},${address.countryName}';
  } else {
    return null;
  }
}
