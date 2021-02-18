import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/back/forecast.dart';

import '../geolocator_helper.dart';
import '../openweathermap_api.dart';
import '../weather.dart';

enum ForecastEvent { getNewForecast, validateExpireState, getCurrentForecast}

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
        var position = await getCurrentLocation();
        var forecast = await _api.getForecastByCoordinates(position);
        yield Forecast(forecast);
        break;
      case ForecastEvent.getNewForecast:
        var position = await getCurrentLocation();
        var forecast = await _api.getForecastByCoordinates(position);
        yield Forecast(forecast);
        break;
      default:
        addError(Exception('unsupported event'));
    }
  }
}