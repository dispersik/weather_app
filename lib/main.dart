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
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ForecastBloc(Forecast(forecast))),
        BlocProvider(create: (context) => WeatherBloc(forecast[0])),
      ],
      child: BlocListener<ForecastBloc, Forecast>(
        listener: (context, state) {
          print('forecast new state: ${state.forecast[0]}');
          context.read<WeatherBloc>().add(WeatherEvent.update);
        },
        child: MaterialApp(home: WeatherPage()),
      ),
    );
  }
}
