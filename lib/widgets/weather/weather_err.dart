import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
    Text('Cannot obtain forecast', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),),
    ElevatedButton(
    onPressed: () => context
        .read<ForecastBloc>()
        .add(ForecastEvent.getNewForecastFromAPI),
    child: Text('try again', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)))
    ]);
  }
}