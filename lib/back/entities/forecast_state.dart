import 'package:flutter/cupertino.dart';
import 'package:weather_app/back/entities/forecast.dart';

enum ForecastStates {
  gettingValue, error, update
}

class ForecastState extends Forecast {
  // used while getting values
  ForecastState.onGet(forecast):super(forecast) {
    gettingValue = true;
    state = ForecastStates.gettingValue;
  }

  // used when there's no error
  ForecastState(forecast) : super(forecast) {
    // state = ForecastStates.get;
  }

  // on error
  ForecastState.onError(forecast, {@required this.error})
      : super(forecast) {
    state = ForecastStates.error;
  }

  ForecastStates state;
  bool gettingValue = false;
  String error;
  bool get haveError => error != null;
}
