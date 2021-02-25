import 'package:flutter/cupertino.dart';
import 'package:weather_app/back/entities/forecast.dart';

class ForecastState extends Forecast {
  // used while getting values
  ForecastState.onGet(forecast):super(forecast) {
    gettingValue = true;
  }

  // used when there's no error
  ForecastState(forecast) : super(forecast);
  // on error
  ForecastState.onError(forecast, {@required this.error})
      : super(forecast);

  bool gettingValue = false;
  String error;
  bool get haveError => error != null;
}
