import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/back/forecast.dart';

import '../../main.dart';
import '../geolocator_helper.dart';
import '../openweathermap_api.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ForecastEvent { getNewForecast, validateExpireState, getCurrentForecast }

class ForecastBloc extends Bloc<ForecastEvent, Forecast> {
  ForecastBloc() : super(null);
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
        }
        if (position != null) {
          try {
            forecast = await _api.getForecastByCoordinates(position);
          } catch (e) {
            print('error in bloc: $e');
            addError(e.toString());
          }
          yield Forecast(forecast);
        } else {
          addError('Cannot determine position');
        }
        break;
      default:
        addError(Exception('unsupported event'));
    }
  }
}
