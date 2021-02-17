import 'package:geolocator/geolocator.dart';

abstract class WeatherAPI {
  Future<List<Weather>> getForecastByCoordinates(Position position);
}

class Weather {
  Weather.fromMap(Map<String, dynamic> map) {
    datetime = DateTime.parse(map['dt_txt'].toString());
    temp =_doubleParser(map['main']['temp']);
    pressure = _doubleParser(map['main']['pressure']);
    humidity = _doubleParser(map['main']['humidity']);
    weatherDescription = WeatherDescription.fromMap(map['weather'][0]);
  }

  DateTime datetime;
  double temp;
  double pressure;
  double humidity;
  WeatherDescription weatherDescription;

  @override
  String toString() =>
      'Weather: ' +
      datetime.toLocal().toString() +
      ' pressure: $pressure' +
      ' temp: $temp' +
      ' humidity: $humidity';
}

class WeatherDescription {
  WeatherDescription.fromMap(Map<String, dynamic> map) {
    main = map['main'];
    description = map['description'];
    iconName = map['icon'];
  }
  String main;
  String description;
  String iconName;

  @override
  String toString() =>
      'Weather description: main: $main, description: $description, icon: $iconName';
}

double _doubleParser(dynamic value)=>double.tryParse(value.toString());