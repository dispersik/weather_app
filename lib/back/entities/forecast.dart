import 'package:flutter/cupertino.dart';
import 'package:weather_app/back/entities/weather.dart';

class Forecast {
  Forecast(this.forecast);

  final List<Weather> forecast;

  Forecast currentForecast() {
    var currentForecast = List<Weather>();
    var now = DateTime.now();
    forecast.forEach((element) {
      if (element.datetime.isAfter(now) ||
          now.difference(element.datetime).inHours < 3)
        currentForecast.add(element);
    });
    return Forecast(currentForecast);
  }
}
