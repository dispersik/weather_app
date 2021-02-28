import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_app/back/bloc/forecast_bloc.dart';
import 'package:weather_app/back/bloc/weather_bloc.dart';
import 'package:weather_app/back/entities/forecast.dart';
import 'package:weather_app/back/entities/forecast_state.dart';
import 'package:weather_app/back/helper.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/widgets/ui_helper.dart';

import '../main.dart';

class ForecastPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ForecastBloc, ForecastState>(
        builder: (context, _forecast) => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              title: Center(
                child: Text('Forecast for ${_cityNameFromForecast(_forecast)}',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w300)),
              ),
            ),
            body: Column(
              children: [
                Container(
                  height: 0.5,
                  color: Colors.black,
                ),
                Expanded(
                  child: ListView.separated(
                      itemCount: _forecast.forecast.length + 5,
                      separatorBuilder: (context, index) => Divider(
                            color: Colors.black,
                          ),
                      itemBuilder: (context, index) =>
                          _buildTiles(context, index, _forecast)),
                ),
              ],
            )));
  }

  Widget _buildTiles(BuildContext context, int index, Forecast forecast) {
    var itemsList = List<ListTile>();
    var _forecast = forecast.forecast;
    itemsList.add(ListTile(
      title: Text('Today',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
    ));
    _forecast.forEach((element) {
      itemsList.add(ListTile(
        shape: Border(
          top: BorderSide(width: double.infinity, color: Colors.black),
        ),
        leading: SvgPicture.asset(
            'assets/opensource_weather_icons/' +
                element.weatherDescription.iconName +
                '.svg',
            height: 40,
            width: 40,
            color: iconColorPicker(element)
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
        onTap: () {
          context.read<WeatherBloc>().add(
              WeatherEvent(type: WeatherEventType.setWeather, value: element));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => WeatherPage()));
        },
      ));
      if (element.datetime.hour == 21)
        itemsList.add(ListTile(
            title: Text(
          weekdayToReadableDay(
              element.datetime.weekday == 7 ? 1 : element.datetime.weekday + 1),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
        )));
    });
    return itemsList[index];
  }

  String _cityNameFromForecast(Forecast forecast) => forecast.forecast[0].city;
}
