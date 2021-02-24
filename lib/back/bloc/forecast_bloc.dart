import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/back/forecast.dart';
import 'package:weather_app/back/forecast_state.dart';
import 'package:weather_app/back/repository/repository_core.dart';
import 'package:weather_app/back/repository/weather_repository.dart';
import 'package:weather_app/back/weather.dart';

import '../../main.dart';
import '../geolocator_helper.dart';
import '../repository/openweathermap_api.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ForecastEvent {
  getAnyForecast,
  getNewForecast,
  validateExpireState,
  getCurrentForecast
}

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  ForecastBloc() : super(null);

  final _api = OpenWeatherMapAPI();
  final _repository = WeatherRepository();

  bool busy = false;

  void _busy() => busy = true;

  void _notBusy() => busy = false;

  @override
  Stream<ForecastState> mapEventToState(ForecastEvent event) async* {
    var forecast;
    _busy();
    switch (event) {
      case ForecastEvent.getAnyForecast:
        try {
          forecast = await _repository.getForecast();
        } catch (e) {
          print(e);
          _notBusy();
          yield ForecastState.onError(_prevState(), error: e.toString());
          break;
        }
        _notBusy();
        yield ForecastState(forecast);
        break;
      case ForecastEvent.getNewForecast:
        _busy();
        try {
        forecast = await _repository.fromAPI();
        } catch(e) {
          print(e);
          _notBusy();
          ForecastState.onError(_prevState(),
              error: e.toString());
          break;
        }
        _notBusy();
        yield ForecastState(forecast);
        break;
      default:
        _notBusy();
        addError(Exception('unsupported event'));
        yield null;
    }
  }

  List<Weather> _prevState() {
    return (state == null) ? null : state.forecast;
  }
}
