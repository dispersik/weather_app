import 'package:flutter/cupertino.dart';
import 'package:weather_app/back/entities/weather.dart';

enum WeatherStates {
  view, gettingValue, err
}

class WeatherState extends Weather {
  WeatherState(Weather weather) : super.copyOf(weather);

  WeatherState.onGet(WeatherState state) : super()/*super.copyOf(state._toWeather())*/ {
    // gettingValue = true;
    this.state = WeatherStates.gettingValue;
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

  WeatherState.onErr(Weather weather)
      : super()/*super.copyOf(weather)*/ {
    state = WeatherStates.err;
  }

  // String err;
  // bool gettingValue = false;
  WeatherStates state = WeatherStates.view;

  // bool get hasErr => err != null;
}
