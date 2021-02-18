import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/back/bloc/forecast_bloc.dart';
import 'package:weather_app/main.dart';

import '../weather.dart';

enum WeatherEvent {
  init,
  update,
}

class WeatherBloc extends Bloc<WeatherEvent, Weather> {
  WeatherBloc(Weather initialState) : super(initialState);

  @override
  Stream<Weather> mapEventToState(WeatherEvent event) async* {
    switch(event) {
      case WeatherEvent.update:
        yield forecast[0];
        break;
    }
    // throw UnimplementedError();
  }
}