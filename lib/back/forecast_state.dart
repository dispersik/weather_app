import 'package:flutter/cupertino.dart';
import 'package:weather_app/back/forecast.dart';

class ForecastState extends Forecast {
  // used when there's no error
  ForecastState(forecast) : super(forecast);

  // on error
  ForecastState.onError(forecast, {@required this.error})
      : super(forecast);

  String error;

  bool get haveError => error != null;
}
