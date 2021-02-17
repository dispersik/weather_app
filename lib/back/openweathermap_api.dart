import 'package:http/http.dart' as http;

Future<dynamic> getCurrentWeather(String location, String apiKey) async {
  var apiLocation = 'http://api.openweathermap.org/data/2.5/';
  var apiQuery = 'weather?q=$location&APPID=$apiKey';
  var uri = apiLocation+apiQuery;

  return http.get(uri);
}
