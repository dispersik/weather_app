import 'package:flutter/cupertino.dart';
import 'package:weather_app/back/entities/weather.dart';

class WeatherState extends Weather {
  WeatherState(Weather weather) : super.copyOf(weather);

  WeatherState.onGet(WeatherState state) : super.copyOf(state._toWeather()) {
    gettingValue = true;
  }

  Weather _toWeather() {
    return Weather(
        city: city,
        weatherDescription: weatherDescription,
        temp: temp,
        pressure: pressure,
        datetime: datetime,
        humidity: humidity);
  }

  WeatherState.onErr(Weather weather, {@required this.err})
      : super.copyOf(weather);
  String err;
  bool gettingValue = false;

  bool get hasErr => err != null;
}
