import 'package:weather_app/back/forecast.dart';
import 'package:weather_app/back/repository/repository_core.dart';

class LocalRepository extends Repository {
  @override
  Future<Forecast> getForecast() {
    // TODO: implement getForecast
    throw UnimplementedError();
  }

  @override
  Future<void> saveForecast(Forecast forecast) {
    // TODO: implement saveForecast
    throw UnimplementedError();
  }
  
}