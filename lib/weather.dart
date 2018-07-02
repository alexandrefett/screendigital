import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:screendigital/models.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({Key key, this.weather}) : super(key: key);
  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.all(8.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(weather.city, style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
            new Text(weather.forecaststxt.forecastsday[0].fcttext_metric, style: new TextStyle(fontSize: 18.0)),
            buildcurrent(weather),
          ],
    ));
  }

  Widget buildday(Forecast day) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(day.weekday_short),
        new Image.asset('assets/${day.icon}.png',scale: 2.5,),
        new Text(day.low.celcius+'/'+day.high.celcius),
        new Text(day.pop+'%')
      ],
    );
  }

  List<Widget> buildforecast(List<Forecast> list) {
    var widgets = [];
    list.forEach((f) {
      widgets.add(buildday(f));
    });
  }

  Widget buildcurrent(Weather weather) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      children: <Widget>[
        new Column(
            children: <Widget>[
          new Image.asset('assets/${weather.currentobservation.icon}.png',scale: 2.0,),
          new Text(weather.currentobservation.temp_c + 'C'),
          new Text(weather.currentobservation.temp_f + 'F'),

        ]),
        buildday(weather.forecasts.forecasts[0]),
        buildday(weather.forecasts.forecasts[1]),
        buildday(weather.forecasts.forecasts[2]),
        buildday(weather.forecasts.forecasts[3])
      ],
    );
  }
}