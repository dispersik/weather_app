import 'package:flutter/cupertino.dart';
import 'package:weather_app/back/entities/weather.dart';

class Forecast {
  Forecast(this.forecast);
  final List<Weather> forecast;
}