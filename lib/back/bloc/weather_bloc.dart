import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/back/entities/weather_state.dart';
import 'package:weather_app/main.dart';

import '../entities/weather.dart';

enum WeatherEventType {
  setWeather,
  setCurrentWeather,
  setByIndex,
  waitForWeather,
  error
}

class WeatherEvent {
  const WeatherEvent({@required this.type, this.value});
  final WeatherEventType type;
  final Weather value;
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(null);
  // [_index] used for loading specific timestamp
  int _index=0;
  void index(int index) {
    if (index>=0) {
      _index = index;
    } else throw Exception('Wrong index value');
  }

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    switch(event.type) {
      case WeatherEventType.waitForWeather:
        yield WeatherState.onGet(state);
        break;
      case WeatherEventType.setWeather:
        yield WeatherState(event.value);
        break;
      case WeatherEventType.error:
        yield WeatherState.onErr(state);
        break;
      case WeatherEventType.setCurrentWeather:
        yield forecast[0];
        break;
      case WeatherEventType.setByIndex:
        yield forecast[_index];
        break;
    }
  }
}