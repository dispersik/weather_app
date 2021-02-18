import 'package:flutter/cupertino.dart';
import 'package:weather_app/back/weather.dart';

class Forecast {
  Forecast(this.forecast);
  final List<Weather> forecast;
}