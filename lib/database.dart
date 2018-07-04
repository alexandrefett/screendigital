import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

class Database{
  static Future<Query> queryMeetings() async {
    return FirebaseDatabase.instance
        .reference()
        .child("events");
  }

  static Future<Query> queryWeather() async {
    return FirebaseDatabase.instance
        .reference()
        .child("cities");
  }

  static Future<Query> queryImages() async {
    return FirebaseDatabase.instance
        .reference()
        .child("images");
  }

}