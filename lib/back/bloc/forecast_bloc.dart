import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/back/forecast.dart';

import '../../main.dart';
import '../geolocator_helper.dart';
import '../openweathermap_api.dart';
import '../weather.dart';

enum ForecastEvent { getNewForecast, validateExpireState, getCurrentForecast }

class ForecastBloc extends Bloc<ForecastEvent, Forecast> {
  ForecastBloc(Forecast initialState) : super(initialState);
  final OpenWeatherMapAPI _api = OpenWeatherMapAPI();

  @override
  Stream<Forecast> mapEventToState(ForecastEvent event) async* {
    switch (event) {
      case ForecastEvent.getCurrentForecast:
        yield state;
        break;
      case ForecastEvent.validateExpireState:
        throw UnimplementedError();
        break;
      case ForecastEvent.getNewForecast:
        var position;
        try {
          position = await getCurrentLocation();
        } catch (e) {
          print('error in bloc: $e');
          position = Position(
              latitude:35.34740561167222, longitude: 139.40772737368098);
        }
        forecast = await _api.getForecastByCoordinates(position);
        yield Forecast(forecast);
        break;
      default:
        addError(Exception('unsupported event'));
    }
  }
}
