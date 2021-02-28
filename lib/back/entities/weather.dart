import 'package:geolocator/geolocator.dart';

abstract class WeatherAPI {
  Future<List<Weather>> getForecastByCoordinates(Position position);
}

class Weather {
  Weather({this.humidity,
    this.temp,
    this.pressure,
    this.weatherDescription,
    this.datetime,
    this.city});

  Weather.copyOf(Weather weather) {
    datetime = weather.datetime;
    temp = weather.temp;
    pressure = weather.pressure;
    humidity = weather.humidity;
    weatherDescription = weather.weatherDescription;
    city = weather.city;
  }

  Weather.fromAPI(Map<String, dynamic> map, String city) {
    datetime = DateTime.parse(map['dt_txt'].toString());
    temp = _doubleParser(map['main']['temp']).round();
    pressure = _doubleParser(map['main']['pressure']).round();
    humidity = _doubleParser(map['main']['humidity']).round();
    weatherDescription = WeatherDescription.fromMap(map['weather'][0]);
    this.city = city;
  }

  Weather.fromDB(Map<String, dynamic> map) {
    datetime = DateTime.parse(map['dt_txt'].toString());
    temp = map['temp'];
    pressure = map['pressure'];
    humidity = map['humidity'];
    weatherDescription = WeatherDescription.fromDB(map['description']);
    city = map['city'];
  }

  DateTime datetime;
  int temp;
  int pressure;
  int humidity;
  WeatherDescription weatherDescription;
  String city;

  int get temperature => (temp - 273).round();

  //TODO
  String toPrettyString() =>
      'Weather in $city at ' +
          datetime.toLocal().toString() +
          ' pressure: $pressure' +
          ' temperature: $temp' +
          ' humidity: $humidity' +
          ' city: $city' +
          ' weather_desc: $weatherDescription';

  List<dynamic> toDB() =>
      [
        datetime.toString(),
        temp,
        pressure,
        humidity,
        weatherDescription.toDB(),
        city
      ];
}

class WeatherDescription {
  WeatherDescription.fromMap(Map<String, dynamic> map) {
    main = map['main'];
    description = map['description'];
    iconName = map['icon'];
  }

  WeatherDescription.fromDB(String string) {
    var values = string.split(',');
    main = values[0].substring(values[0].indexOf(' ') + 1);
    description = values[1].substring(values[1].indexOf(' ', 1) + 1);
    iconName = values[2].substring(values[2].indexOf(' ', 1) + 1);
  }

  String main;
  String description;
  String iconName;

  @override
  String toString() =>
      'Weather description: main: $main, description: $description, icon: $iconName';

  String toDB() => 'main: $main, description: $description, icon: $iconName';
}

double _doubleParser(dynamic value) => double.tryParse(value.toString());
