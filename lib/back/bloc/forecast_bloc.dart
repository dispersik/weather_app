import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/back/entities/forecast.dart';
import 'package:weather_app/back/entities/forecast_state.dart';
import 'package:weather_app/back/repository/weather_repository.dart';
import 'package:weather_app/back/entities/weather.dart';

enum ForecastEvent {
  getForecast,
  getNewForecastFromAPI,
}

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  ForecastBloc() : super(null);

  final repository = WeatherRepository();

  @override
  Stream<ForecastState> mapEventToState(ForecastEvent event) async* {
    var forecast;
    switch (event) {
      case ForecastEvent.getForecast:
        yield ForecastState.onGet(_prevState());
        try {
          forecast = await repository.getForecast();
        } catch (e) {
          print(e);
          yield ForecastState.onError(_prevState(), error: e.toString());
          break;
        }
        yield ForecastState(forecast.forecast);
        break;

      case ForecastEvent.getNewForecastFromAPI:
        yield ForecastState.onGet(_prevState());
        try {
          forecast = await repository.fromAPI();
        } catch (e) {
          print('err: $e');
          yield ForecastState.onError(_prevState(), error: e.toString());
          break;
        }
        repository.localRep.updateForecast(forecast);
        yield ForecastState(forecast.forecast);
        break;

      default:
        addError(Exception('unsupported event'));
        yield null;
    }
  }

  List<Weather> _prevState() {
    return (state == null) ? null : state.forecast;
  }
}
