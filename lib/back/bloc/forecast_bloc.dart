import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/back/forecast.dart';
import 'package:weather_app/back/forecast_state.dart';
import 'package:weather_app/back/weather.dart';

import '../../main.dart';
import '../geolocator_helper.dart';
import '../openweathermap_api.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ForecastEvent { getNewForecast, validateExpireState, getCurrentForecast }

class ForecastBloc extends Bloc<ForecastEvent, ForecastState> {
  ForecastBloc() : super(null);
  final _api = OpenWeatherMapAPI();

  bool busy = false;
  void _busy() => busy = true;
  void _notBusy() => busy = false;

  @override
  Stream<ForecastState> mapEventToState(ForecastEvent event) async* {
    _busy();
    switch (event) {
      // case ForecastEvent.getCurrentForecast:
      //   yield state;
      //   break;
      // case ForecastEvent.validateExpireState:
      //   throw UnimplementedError();
      //   break;
      case ForecastEvent.getNewForecast:
        // firstly check permissions
        try {
          await checkAccessability();
        } catch (e) {
          _notBusy();
          yield ForecastState.onError(_prevState(), error: e.toString());
          break;
        }
        // if ok, trying to obtain current position
        var position;
        try {
          position = await getCurrentLocationBrute();
        } catch (e) {
          print('error in bloc: $e');
          _notBusy();
          yield ForecastState.onError(_prevState(), error: e.toString());
          break;
        }
        // getting forecast from the api
        try {
          forecast = await _api.getForecastByCoordinates(position);
        } catch (e) {
          print('error in bloc: $e');
          _notBusy();
          yield ForecastState.onError(_prevState(),
              error: 'No Internet access');
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
