import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:screendigital/database.dart';
import 'package:screendigital/models.dart';
import 'package:screendigital/weather.dart';

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
            body2: new TextStyle(color: Colors.white))),
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
  final PageController _pageController = new PageController();
  Query _query;
  Query _queryWeather;
  Query _queryImages;
  bool _hasEvent = false;

  Widget buildListWeather() {
    return new StreamBuilder<Event>(
        stream: _queryWeather.onValue,
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

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    Database.queryMeetings().then((Query query) {
      setState(() {
        _query = query;
      });
    });
    Database.queryWeather().then((Query query) {
      setState(() {
        _queryWeather = query;
      });
    });
    Database.queryImages().then((Query query) {
      setState(() {
        _queryImages = query;
      });
    });
    super.initState();
  }

  void startFlipping() {
    const sleep = const Duration(seconds: 15);
    _pageController.nextPage(
        duration: Duration(seconds: 1), curve: Curves.ease);
    new Timer(sleep, () => startFlipping());
  }

  @override
  Widget build(BuildContext context) {
    Widget body = new StreamBuilder<Event>(
        stream: _query.onValue,
        builder: (BuildContext context, AsyncSnapshot<Event> event) {
          if (event.hasData) {
            if (event.data.snapshot.value != null) {
              setState(() {
                _hasEvent = true;
              });
              return new ListView.builder(
                  itemCount: event.data.snapshot.value.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> map = new Map<String, dynamic>.from(
                        event.data.snapshot.value[index]);
                    return new ListTile(
                      title: new Text(map['description']),
                      subtitle: new Text(map['location']),
                    );
                  });
            }
            else {
              setState(() {
                _hasEvent = false;
              });
            }
          }
          return new Text('Loading...');
        });

    Widget bodyBanner = new PageView.builder(
        physics: new AlwaysScrollableScrollPhysics(),
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
          return StreamBuilder<Event>(
              stream: _queryWeather.onValue,
              builder: (BuildContext context, AsyncSnapshot<Event> event) {
                if (event.hasData) {
                  if (event.data.snapshot.value != null) {
                    Map<String, dynamic> map = new Map<String, dynamic>.from(
                        event.data.snapshot.value[index]);
                    Weather weather = Weather.fromJson(map);
                    return new Column(children: <Widget>[
                      new WeatherCard(weather: weather)
                    ]);
                  }
                  return new Text('Loading...');
                }
                return new Text('Loading...');
              });
        });

    Widget bodyWeather = new StreamBuilder<Event>(
      stream: _queryWeather.onValue,
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

    if (_hasEvent) {
      return new Scaffold(
        backgroundColor: new Color.fromARGB(255, 0, 77, 105),
        body: new Padding(
          padding: new EdgeInsets.all(8.0),
          child: new Column(
              mainAxisSize: MainAxisSize.max, children: <Widget>[
            new Expanded(
                child: new Image.asset('assets/icon-512x512.jpg'), flex: 3),
            new Expanded(child: body, flex: 10),
            new Expanded(child: bodyBanner, flex: 5)
          ])));
    } else {
      return new Scaffold(
        backgroundColor: new Color.fromARGB(255, 0, 77, 105),
        body: new Padding(
          padding: new EdgeInsets.all(8.0),
          child: new Column(
              mainAxisSize: MainAxisSize.max, children: <Widget>[
            new Expanded(
                child: new Image.asset('assets/icon-512x512.jpg'), flex: 3),
            new Expanded(child: bodyWeather, flex: 10),
          ])));
    }
  }
}
