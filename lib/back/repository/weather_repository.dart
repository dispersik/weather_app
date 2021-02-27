import 'package:weather_app/back/entities/forecast.dart';
import 'package:weather_app/back/entities/weather.dart';
import 'package:weather_app/back/geolocator_helper.dart';
import 'package:weather_app/back/repository/openweathermap_api.dart';
import 'package:weather_app/back/repository/repository_core.dart';
import 'package:weather_app/back/repository/repository_local.dart';

class WeatherRepository extends Repository {
  WeatherRepository._();

  factory WeatherRepository() {
    return _repository;
  }

  static final WeatherRepository _repository = WeatherRepository._();
  final localRep = LocalRepository();
  final api = OpenWeatherMapAPI();

  @override
  Future<Forecast> getForecast() async {
    // TODO change logic to try/catch
    var forecast = await fromAPI();
    if (forecast == null) {
      try {
        forecast = await localRep.getForecast();
      } catch (e) {
        print(e);
      }
    }
    return forecast;
  }

  Future<Forecast> fromAPI() async {
    var forecast;
    if (await api.pingAPI()) {
      var position;
      try {
        position = await geolocatorRoutine();
      } catch (e) {
        print(e);
        return Future.error(e);
      }
      if (position != null) {
        try {
          forecast = await api.getForecastByCoordinates(position);
        } catch (e) {
          print(e);
          return Future.error('No Internet connection');
        }
      }
      return Forecast(forecast);
    }
    return Future.error('No Internet connection');
  }

  @override
  Future<void> saveForecast(Forecast forecast) {
    try {
      localRep.saveForecast(forecast);
    } catch(e) {
      print(e);
      return Future.error('Local weather save failed');
    }
    return null;
  }
}
