import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/back/bloc/forecast_bloc.dart';
import 'package:weather_app/back/entities/weather_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherErr extends StatelessWidget {
  WeatherErr(this.weather);
  
  final WeatherState weather;
  
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
    Text('Cannot obtain forecast'),
    ElevatedButton(
    onPressed: () => context
        .read<ForecastBloc>()
        .add(ForecastEvent.getNewForecast),
    child: Text('try again'))
    ]);
  }
}