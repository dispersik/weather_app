import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/back/geolocator_helper.dart';
import 'package:weather_app/back/openweathermap_api.dart';
import 'package:weather_app/back/weather.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:weather_app/widgets/weather_widget.dart';

// void main() {
//   runApp(WeatherApp());
// }
//
// class WeatherApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Weather',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       // home: MyHomePage(title: 'Weather'),
//       home: Home(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final weatherAPI = OpenWeatherMapAPI();
//   Position currentLocation;
//   List<Address> detailedAddress;
//   List<Weather> weatherList;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//                 onPressed: () async {
//                   currentLocation = /*await getCurrentLocation() ??*/
//                       Position(
//                           // latitude: 52.42536875588388,
//                           // longitude: 31.021136747104755
//                           latitude: 52.35308471250674,
//                           longitude: 31.106725359980484);
//                   print(currentLocation);
//                   weatherList = await weatherAPI.getForecastByCoordinates(currentLocation);
//                   print(weatherList);
//                 },
//                 child: Text('getCurrentLocation'))
//           ],
//         ),
//       ),
//     );
//   }
// }
/// Custom [BlocObserver] which observes all bloc and cubit instances.
class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(Cubit cubit, Change change) {
    print(change);
    super.onChange(cubit, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(cubit, error, stackTrace);
  }
}

List<Weather> forecast = List<Weather>();

Future<List<Weather>> _getForecastRoutine() async {
  final weatherAPI = OpenWeatherMapAPI();
  final currentLocation = /*await getCurrentLocation() ??*/
      Position(
          // latitude: 52.42536875588388,
          // longitude: 31.021136747104755
          latitude: 52.35308471250674,
          longitude: 31.106725359980484);
  print(currentLocation);
  final weatherList =
      await weatherAPI.getForecastByCoordinates(currentLocation);
  print(weatherList);
  return weatherList;
}

Future<void> main() async {
  forecast = await _getForecastRoutine();
  Bloc.observer = SimpleBlocObserver();
  runApp(App());
}

class App extends StatelessWidget {
  final Weather _weather = forecast[0];
  final forecastBloc = ForecastBloc(forecast);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => ForecastBloc(forecast),
        child: BlocProvider(
          create: (_) => WeatherBloc(_weather),
          child: WeatherPage(),
        ),
      ),
    );
  }

  void dispose() {
    forecastBloc.close();
  }
}

class ForecastPage extends StatelessWidget {
  String _weekdayToReadableDay(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Thuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
    }
  }

  @override
  Widget build(BuildContext context) {
    var itemsList = List<ListTile>();
    itemsList.add(ListTile(
      title: Text('TODAY'),
    ));
    forecast.forEach((element) {
      itemsList.add(ListTile(
        shape: Border(
            bottom: BorderSide(width: double.infinity, color: Colors.black)),
        leading: Image.asset(
          'assets/openweathermap_icons/' +
              element.weatherDescription.iconName +
              '.png',
          scale: 1,
          isAntiAlias: true,
        ),
        title: Text('${element.datetime.hour}:00'),
        subtitle: Text('${element.weatherDescription.description}'),
        trailing: Text(
          '${element.temperature}°C',
          style: TextStyle(
              fontSize: 40,
              color: Colors.lightBlueAccent,
              fontWeight: FontWeight.w300),
        ),
      ));
      if (element.datetime.hour == 21)
        itemsList.add(ListTile(
            title: Text(_weekdayToReadableDay(element.datetime.weekday))));
    });

    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: Center(
            child: Text('Forecast for ${forecast[0].city}'),
          ),
        ),
        body:
            /* BlocBuilder<ForecastBloc, List<Weather>>(
        cubit: App.forecastBloc,
        builder: (_, _forecast) {
          var itemsList;
          forecast.forEach((element) => itemsList.add(ListTile(
                title: Text('${element.datetime.hour}:00'),
              )));
          return */
            ListView(
          children: [...itemsList],
        ) /*;
        },
      ),*/
        );
  }
}

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: const Text(
          'Weather',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
        )),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: BlocBuilder<WeatherBloc, Weather>(
        builder: (_, weather) {
          return SizedBox.expand(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  WeatherWidget(weather: weather),
                  SizedBox(
                    height: 100,
                  ),
                  GestureDetector(
                    child: Text('Forecast for 5 days'),
                    onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForecastPage())),
                  )
                ]),
          );
        },
      ),
    );
  }
}

enum WeatherViewEvent {
  init,
  change,
}

class WeatherBloc extends Bloc<WeatherViewEvent, Weather> {
  WeatherBloc(Weather initialState) : super(initialState);

  @override
  Stream<Weather> mapEventToState(WeatherViewEvent event) async* {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }
}

enum ForecastEvent { upToDate, outDated }

class ForecastBloc extends Bloc<ForecastEvent, List<Weather>> {
  ForecastBloc(List<Weather> initialState) : super(List<Weather>());
  final OpenWeatherMapAPI _api = OpenWeatherMapAPI();

  @override
  Stream<List<Weather>> mapEventToState(ForecastEvent event) async* {
    switch (event) {
      case ForecastEvent.outDated:
        var position = await getCurrentLocation();
        var newState = await _api.getForecastByCoordinates(position);
        yield newState;
        break;
      case ForecastEvent.upToDate:
        break;
      default:
        addError(Exception('unsupported event'));
    }
  }
}

//
// class CounterBloc extends Bloc<CounterEvent, int> {
//   /// {@macro counter_bloc}
//   CounterBloc() : super(0);
//
//   @override
//   Stream<int> mapEventToState(CounterEvent event) async* {
//     switch (event) {
//       case CounterEvent.decrement:
//         yield state - 1;
//         break;
//       case CounterEvent.increment:
//         yield state + 1;
//         break;
//       default:
//         addError(Exception('unsupported event'));
//     }
//   }
// }
//
// /// {@template brightness_cubit}
// /// A simple [Cubit] which manages the [ThemeData] as its state.
// /// {@endtemplate}
// class ThemeCubit extends Cubit<ThemeData> {
//   /// {@macro brightness_cubit}
//   ThemeCubit() : super(_lightTheme);
//
//   static final _lightTheme = ThemeData(
//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       foregroundColor: Colors.white,
//     ),
//     brightness: Brightness.light,
//   );
//
//   static final _darkTheme = ThemeData(
//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       foregroundColor: Colors.black,
//     ),
//     brightness: Brightness.dark,
//   );
//
//   /// Toggles the current brightness between light and dark.
//   void toggleTheme() {
//     emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
//   }
// }
