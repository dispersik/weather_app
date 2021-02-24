import '../forecast.dart';

abstract class Repository {
  Future<Forecast> getForecast();
  Future<void> saveForecast(Forecast forecast);
}