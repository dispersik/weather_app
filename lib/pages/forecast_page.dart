
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

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
    int _bias = 1;
    var itemsList = List<ListTile>();
    Widget _buildTiles(BuildContext context, int index) {
      return itemsList[index];
    }

    itemsList.add(ListTile(
      title: Text('Today',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
    ));
    forecast.forEach((element) {
      itemsList.add(ListTile(
        shape: Border(
          top: BorderSide(width: double.infinity, color: Colors.black),
          // bottom: BorderSide(width: double.infinity, color: Colors.black)
        ),
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
            title: Text(
              _weekdayToReadableDay(element.datetime.weekday),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            )));
    });

    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: Text('Forecast for ${forecast[0].city}',
                  style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w300)),
            ),
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
        Column(
          children: [
            Container(height: 0.5, color: Colors.black,),
            Expanded(
              child: ListView.separated(
                  itemCount: forecast.length + 5,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.black,
                  ),
                  itemBuilder: _buildTiles),
            ),
          ],
        )
      /*;
        },
      ),*/
    );
  }
}