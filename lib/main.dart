import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/back/forecast.dart';
import 'package:weather_app/back/openweathermap_api.dart';
import 'package:weather_app/back/weather.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:weather_app/pages/weather_page.dart';

import 'back/bloc/bloc_core.dart';
import 'back/bloc/forecast_bloc.dart';
import 'back/bloc/weather_bloc.dart';

List<Weather> forecast = List<Weather>();

Future<void> _getForecastRoutine() async {
  final weatherAPI = OpenWeatherMapAPI();
  final currentLocation = /*await getCurrentLocation() ??*/
      Position(latitude: 59.99622572385836, longitude: 29.760391924380315);
  print(currentLocation);
  final weatherList =
      await weatherAPI.getForecastByCoordinates(currentLocation);
  print(weatherList);
  forecast = weatherList;
}

Future<void> main() async {
  await _getForecastRoutine();
  Bloc.observer = SimpleBlocObserver();
  runApp(App());
}

class App extends StatefulWidget {
  // ignore: close_sinks
  final forecastBloc = ForecastBloc(Forecast(forecast));

  // ignore: close_sinks
  final weatherBloc = WeatherBloc(forecast[1]);

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // widget.forecastBloc.add(ForecastEvent.getNewForecast);
    // widget.weatherBloc.add(WeatherViewEvent.init);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => ForecastBloc(Forecast(forecast)),
        child: BlocBuilder<ForecastBloc, Forecast>(
          builder: (_, _forecast) => MaterialApp(
            home: BlocProvider(
              create: (_) => WeatherBloc(_forecast.forecast[0]),
              child: BlocBuilder<WeatherBloc, Weather>(
                builder: (_, weather) => WeatherPage(weather),
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    widget.forecastBloc.close();
    widget.weatherBloc.close();
  }
}
