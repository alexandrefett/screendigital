import 'package:flutter/material.dart';
import 'package:screendigital/models.dart';

  Widget buildday(Forecast day){
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(day.weekday_short),
        new Image.asset(day.icon+'.png'),
        new Text(day.high.celcius),
        new Text(day.pop)
      ],
    );
  }

  List<Widget> buildforecast(List<Forecast> list){
    var widgets =[];
    list.forEach((f){
      widgets.add(buildday(f));
    });
  }

  Widget buildcurrent(Weather weather){
   return new Row(
     children: <Widget>[
       new Column(children: <Widget>[
         new Image.asset(weather.currentobservation.icon+'.png'),
         new Text(weather.currentobservation.temp_c+'c'),
         new Text(weather.currentobservation.temp_f+'f'),
         new Text(weather.currentobservation.uv+' UV'),
       ]),
       buildday(weather.forecasts[0]),
       buildday(weather.forecasts[1]),
       buildday(weather.forecasts[2]),
       buildday(weather.forecasts[3])
     ],
   );
  }

  Widget buildweather(Weather weather){
    return new Column(
      children: <Widget>[
        new Text(weather.city),
        new Text(weather.forecaststxt[0].fcttext_metric),
        buildcurrent(weather),
      ],
    );
  }

