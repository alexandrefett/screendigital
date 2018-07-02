import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:screendigital/database.dart';
import 'package:screendigital/models.dart';
import 'package:screendigital/weather.dart';
import 'package:carousel_slider/carousel_slider.dart';

FirebaseUser user;

Future<void> main() async {
  user = await FirebaseAuth.instance.signInAnonymously();
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: const FirebaseOptions(
      googleAppID: '1:990343580564:android:19fd4b25551b08ea',
      apiKey: 'AIzaSyCfD19geKC_N5ZsnL8-zk9og9zUhUOhK58',
      databaseURL: 'https://digitalsignage-a824c.firebaseio.com',
    ),
  );
  runApp(new MaterialApp(
    title: 'Flutter Demo',
    theme: new ThemeData(
        accentColor: Colors.white,
        primaryColor: Colors.white,
        primarySwatch: Colors.blue,
        textTheme: new TextTheme(
            body1: new TextStyle(color: Colors.white),
            body2: new TextStyle(color: Colors.white),
            subhead: new TextStyle(color: Colors.white),
            title:   new TextStyle(color: Colors.white),
        )),
    home: new MyHomePage(app: app),
  ));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.app});
  final FirebaseApp app;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {

  PageController _pageController;
  Query _query;
  Query _queryWeather;
  Query _queryImages;
  bool _hasEvent = false;
  List<Widget> fullPage;
  int pageCount = 0;

  Widget bodyWeather(Query query) {
    return new StreamBuilder<Event>(
        stream: query.onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {
          if (event.hasData) {
            if (event.data.snapshot.value != null) {
              return new ListView.builder(
                  itemCount: event.data.snapshot.value.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> map = new Map<String, dynamic>.from(
                        event.data.snapshot.value[index]);
                    return new WeatherCard(weather: Weather.fromJson(map));
                  });
            }
          }
          return new Text('Loading...');
        });
  }

  void getImages() {
    _queryImages.onValue.forEach((Event event) {
      for (int i = 0; i < event.snapshot.value.length; i++) {
        Map<String, dynamic> map =
            new Map<String, dynamic>.from(event.snapshot.value[i]);
          fullPage.add(new Image.network(map['url']));
        print(map['url']);
      }
    });
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    fullPage = new List<Widget>();
    Database.queryMeetings().then((Query query) {
      setState(() {
        _query = query;
      });
    });
    Database.queryWeather().then((Query query) {
      setState(() {
        _queryWeather = query;
        fullPage.add(bodyWeather(_queryWeather));
      });
    });
    Database.queryImages().then((Query query) {
      setState(() {
        _queryImages = query;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = new Text('Loading...');
    Widget bodyWeather = new Text('Loading...');

    if (_query != null) {
      body = new StreamBuilder<Event>(
          stream: _query.onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> event) {
            if (event.hasData) {
              if (event.data.snapshot.value != null) {
                _hasEvent = true;
                return new ListView.builder(
                    itemCount: event.data.snapshot.value.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> map = new Map<String, dynamic>.from(
                          event.data.snapshot.value[index]);
                      return new ListTile(
                        title: new Text(map['description'],
                            style: new TextStyle(color: Colors.white,fontSize: 22.0)),
                        subtitle: new Text(map['location'],
                            style: new TextStyle(color: Colors.white)),
                      );
                    });
              }
            }
            return new Text('Loading...');
          });
    }
    else{
      _hasEvent = false;
    }

    if (_queryWeather != null) {
      bodyWeather = new StreamBuilder<Event>(
          stream: _queryWeather.onValue,
          builder: (BuildContext context, AsyncSnapshot<Event> event) {
            if (event.hasData) {
              if (event.data.snapshot.value != null) {
                pageCount = event.data.snapshot.value.length;
                if(_hasEvent) {
                  return new CarouselSlider(
                    items: event.data.snapshot.value.map<Widget>((item) {
                      print(item);
                      return new Builder(builder: (BuildContext context) {
                        Map<String, dynamic> map = new Map<String, dynamic>.from(item);
                        return new Column(
                            children: <Widget>[
                              new WeatherCard(weather: Weather.fromJson(map))
                            ]);
                      });
                    }).toList(),
                    autoPlay: true,
                    interval: new Duration(seconds: 15),
                    viewportFraction: 1.0,
                  );
                }
                else{
                  return new ListView.builder(
                      itemCount: event.data.snapshot.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map<String, dynamic> map = new Map<String,
                            dynamic>.from(
                            event.data.snapshot.value[index]);
                        return new WeatherCard(weather: Weather.fromJson(map));
                      });
                }
              }
            }
            return new Text('Loading...');
          });
    }
    if (_hasEvent) {
      return new Scaffold(
        backgroundColor: new Color.fromARGB(255, 0, 77, 105),
        body: new Padding(
          padding: new EdgeInsets.all(8.0),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Expanded(
                child: new Image.asset('assets/icon-512x512.jpg'), flex: 4),
              new Expanded(child: body, flex: 10),
              new Expanded(child: bodyWeather, flex: 7)
          ])));
    } else {
      getImages();
      return new Scaffold(
        backgroundColor: new Color.fromARGB(255, 0, 77, 105),
        body: new PageView.builder(
          physics: new AlwaysScrollableScrollPhysics(),
          itemCount: fullPage.length,
          controller: _pageController,
          itemBuilder: (BuildContext context, int index) {
            print(fullPage.length);
            return fullPage[index];
          }
        )
      );
    }
  }
}
