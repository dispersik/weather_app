import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class ForecastDB {
  static Database _db;

  Future<Database> init() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "forecast.db");
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<Database> get db async {
    if (_db==null) _db = await init();
    return _db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Forecast(id INTEGER PRIMARY KEY, dt_txt TEXT, temp INT, pressure INT, humidity INT, description TEXT, city TEXT )");
    print("Table created");
  }

  Future<Forecast> getForecast() async {
    dbClient = await db;
    List<Map> list;
    await dbClient.transaction((txn) async {
      list = await txn.rawQuery('SELECT * FROM Forecast;');
    });
    var forecast = List<Weather>();
    list.forEach((weather) {
      forecast.add(Weather.fromDB(weather));
    });
    return Forecast(forecast);
  }

  Future<void> deleteForecast() async {
    dbClient = await db;
    await dbClient.transaction((txn) async {
      txn.rawQuery('DELETE FROM Forecast;');
    })
  }

  Future<void> insertForecast(Forecast forecast) async {
    dbClient = await db;
    await dbClient.transaction((txn) async {
      forecast.forEach((weather) async {
        await txn.rawInsert('INSERT INTO Forecast(dt_txt, temp, pressure, humidity, description, city) VALUES(?,?,?,?,?,?);',
        weather.toDB());
      });
    });
  }
}