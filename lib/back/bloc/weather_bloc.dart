import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/back/bloc/forecast_bloc.dart';
import 'package:weather_app/main.dart';

import '../weather.dart';

enum WeatherEvent {
  setCurrentWeather,
  setByIndex,
}

class WeatherBloc extends Bloc<WeatherEvent, Weather> {
  // WeatherBloc(Weather initialState) : super(initialState);
  WeatherBloc() : super(null);
  // [_index] used for loading specific timestamp
  int _index=0;
  void index(int index) {
    if (index>=0) {
      _index = index;
    } else throw Exception('Wrong index value');
  }

  @override
  Stream<Weather> mapEventToState(WeatherEvent event) async* {
    switch(event) {
      case WeatherEvent.setCurrentWeather:
        yield forecast[0];
        break;
      case WeatherEvent.setByIndex:
        yield forecast[_index];
        break;
    }
    // throw UnimplementedError();
  }
}