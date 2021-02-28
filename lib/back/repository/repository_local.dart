import 'package:weather_app/back/entities/forecast.dart';
import 'package:weather_app/back/repository/database_helper.dart';
import 'package:weather_app/back/repository/repository_core.dart';

class LocalRepository extends Repository {
  final forecastDB = ForecastDB();

  @override
  Future<Forecast> getForecast() async =>
      forecastDB.getForecast().then((value) => value.currentForecast());

  @override
  Future<void> saveForecast(Forecast forecast) async =>
      await forecastDB.insertForecast(forecast);

  Future<void> updateForecast(Forecast forecast) async {
    await forecastDB.deleteForecast();
    await forecastDB.insertForecast(forecast.currentForecast());
  }
}
