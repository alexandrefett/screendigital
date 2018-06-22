import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:screendigital/models.dart';

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

class _MyHomePageState extends State<MyHomePage> {
  DatabaseReference _eventsRef;
  DatabaseReference _weatherRef;
  DatabaseReference _imagesRef;
  StreamSubscription<Event> _eventsSub;
  StreamSubscription<Event> _weatherSub;
  StreamSubscription<Event> _imagesSub;

  List<Meeting> items = List();

  @override
  void initState() {
    super.initState();
    final FirebaseDatabase database = new FirebaseDatabase(app: widget.app);

    _eventsRef = database.reference().child('events');
    _weatherRef = database.reference().child('weather');
    _imagesRef = database.reference().child('images');

    //_eventsRef.onChildAdded.listen(_onEventAdded);
    //_eventsRef.onChildRemoved.listen(_onEventRemoved);
    //_eventsRef.onChildChanged.listen(_onEventChanged);

    _eventsSub = _eventsRef.onValue.listen((data) {
      print('----------------');
      print(data.snapshot.value);
    });
  }

  _onEventAdded(Event event) {
    setState(() {
      items.add(Meeting.fromJson(event.snapshot));
    });
  }

  _onEventRemoved(Event event) {
    setState(() {
      items.add(Meeting.fromJson(event.snapshot));
    });
  }

  _onEventChanged(Event event) {
    var old = items.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      items[items.indexOf(old)] = Meeting.fromJson(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    new StreamBuilder(
        stream: FirebaseDatabase.instance.reference().child('events').onValue,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              return new ListView(
                children: snapshot.data.documents.map((DataSnapshot document) {
                  return new ListTile(
                    title: new Text(document.value['description']),
                    subtitle: new Text(document.value['location']),
                  );
                }).toList(),
              );
            }
          }
        });
  }

  @override
  void dispose() {
    super.dispose();
    _eventsSub.cancel();
  }
}
