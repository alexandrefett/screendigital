import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:screendigital/database.dart';
import 'package:screendigital/models.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:screendigital/weather.dart';
import 'package:carousel/carousel.dart';

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
      primarySwatch: Colors.blue,
    ),
    home: new MyHomePage(app: app),
  ));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.app});
  final FirebaseApp app;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  PageController _pageController;
  Query _query;
  Query _queryWeather;

  @override
  void initState() {
    Database.queryMeetings().then((Query query) {
      setState(() {
        _query = query;
      });
    });
    Database.queryWeather().then((Query query) {
      setState(() {
        print(query);
        _queryWeather = query;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget body = new ListView(
      children: <Widget>[
        new ListTile(
          title: new Text("The list is empty..."),
        )
      ],
    );

    if (_query != null) {
      body = new FirebaseAnimatedList(
        query: _query,
        itemBuilder: (
            BuildContext context,
            DataSnapshot snapshot,
            Animation<double> animation,
            int index,
            ) {
          String mountainKey = snapshot.key;
          Map map = snapshot.value;
          String description = map['description'] as String;
          String location = map['location'] as String;
          return new Column(
            children: <Widget>[
              new ListTile(
                title: new Text('$description'),
                subtitle: new Text('$location'),
              ),
              new Divider(
                height: 1.0,
              ),
            ],
          );
        },
      );
    }
/*    if(_queryWeather != null){
      body = new FirebaseAnimatedList(
        query: _queryWeather,
        itemBuilder: (
            BuildContext context,
            DataSnapshot snapshot,
            Animation<double> animation,
            int index,
            ) {
         // String mountainKey = snapshot.key;
          Map<String, dynamic> map = new Map<String, dynamic>.from(snapshot.value);
          Weather weather = Weather.fromJson(map);
          return new Column(
            children: <Widget>[
              new WeatherCard(weather: weather),
              new Divider(
                height: 1.0,
              ),
            ],
          );
        },
      );
    }
    */
    return new Scaffold(
      body: new Column(
          children: <Widget>[
            new Image.asset('assets/logo_b.jpg'),
            new Flexible(child: body),

          ]
      ),
    );
  }

  Widget buildTab(){
    List<Weather> list = new List<Weather>();
    _queryWeather.onValue.listen((event){
      list.add(Weather.fromJson(event.snapshot.value));
    });
    new PageView.builder(
        physics: new AlwaysScrollableScrollPhysics(),
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
    return _pages[index % _pages.length];
    }
    );
  }
}
