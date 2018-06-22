
import 'package:firebase_database/firebase_database.dart';

class Meeting {
  String description;
  String location;
  String key;

  Meeting({this.description, this.location, this.key});

  factory Meeting.fromJson(DataSnapshot map){
    return new Meeting(
      description: map.value['description'],
      location: map.value['location'],
      key: map.key
    );
  }
}

class Weather extends Object{
  final String city;
  final List<Forecast> forecasts;
  final List<ForecastDay> forecaststxt;
  final CurrentObservation currentobservation;

  Weather({this.city, this.forecasts, this.currentobservation, this.forecaststxt});

  factory Weather.fromJson(DataSnapshot map){

    List<Forecast> _getList(Map<String, dynamic> map) {
      List<Forecast> list = new List<Forecast>();
      List element =  map.values as List;
      element.forEach((item){
        Forecast f = Forecast.fromJson(item);
        list.add(f);
      });
      return list;
    }

    List<ForecastDay> _getDayList(Map<String, dynamic> map) {
      List<ForecastDay> list = new List<ForecastDay>();
      List element =  map as List;
      element.forEach((item){
        ForecastDay f = ForecastDay.fromJson(item);
        list.add(f);
      });
      return list;
    }

    return new Weather(
      city: map.value['city'],
      forecasts: _getList(map.value['forecast']['forecast']['simpleforecast']['forecastday']),
      currentobservation: CurrentObservation.fromJson(map.value['weather']['current_observation']),
      forecaststxt: _getDayList(map.value['forecast']['txt_forecast']['forecastday'])
    );
  }
}

class CurrentObservation extends Object{
  final String icon;
  final String temp_c;
  final String temp_f;
  final String uv;
  final String windir;

  CurrentObservation({this.icon, this.temp_c, this.temp_f, this.uv, this.windir});

  factory CurrentObservation.fromJson(Map<String, dynamic> map){
    return new CurrentObservation(
      icon: map['icon'].toString(),
      temp_c: map['temp_c'].toString(),
      temp_f: map['temp_f'].toString(),
      uv: map['UV'].toString(),
      windir: map['windir'].toString()
    );
  }
}

class ForecastDay extends Object {
  final String fcttext;
  final String fcttext_metric;
  final String icon;
  final String pop;
  final String title;

  ForecastDay({this.fcttext, this.fcttext_metric, this.icon, this.pop,
      this.title});

  factory ForecastDay.fromJson(Map<String, dynamic> map) {
    return new ForecastDay(
      pop: map['pop'].toString(),
      icon: map['icon'].toString(),
      title: map['title'].toString(),
      fcttext: map['fcttext'].toString(),
      fcttext_metric: map['fcttext_metric'].toString()
    );
  }
}

class Forecast extends Object{
  final String conditions;
  final String avehumidity;
  final Wind avewind;
  final Temp high;
  final Temp low;
  final String icon;
  final String pop;
  final String weekday_short;

  Forecast({this.conditions, this.avehumidity, this.avewind, this.high, this.low,
      this.icon, this.pop, this.weekday_short});

  factory Forecast.fromJson(Map<String, dynamic> map){
    return new Forecast(
      avehumidity: map['avehumidity'].toString(),
      conditions: map['conditions'].toString(),
      avewind: Wind.fromJson(map['avewind']),
      high: Temp.fromJson(map['high']),
      low: Temp.fromJson(map['low']),
      icon: map['icon'].toString(),
      pop: map['pop'].toString(),
      weekday_short: map['date']['weekday_short'].toString()
    );
  }
}

class SimpleForecast extends Object{
  final List<Forecast> forecastList;
}

class Temp extends Object{
  final String celcius;
  final String fahrenheit;

  Temp({this.celcius, this.fahrenheit});

  factory Temp.fromJson(Map<String, dynamic> map){
    return new Temp(
      celcius: map['celcius'].toString(),
      fahrenheit: map['fahrenheit'].toString(),
    );
  }
}

class Wind extends Object{
  final String degrees;
  final String dir;
  final String kph;
  final String mph;

  Wind({this.degrees, this.dir, this.kph, this.mph});

  factory Wind.fromJson(Map<String, dynamic> map){
    return new Wind(
      degrees: map['degrees'].toString(),
      dir: map['dir'].toString(),
      kph: map['kph'].toString(),
      mph: map['mph'].toString(),
    );
  }
}


