import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:migraine_killer/pages.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Migraine Killer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MenuPage(),
      );

  @override
  void initState() {
    super.initState();

    _scheduleReminderNotification(Time(9));
    _scheduleReminderNotification(Time(22));
  }

  Future _scheduleReminderNotification(Time time) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'mk_001',
      'reminder',
      'quiz reminder',
      icon: 'think_36',
      largeIcon: 'think_48',
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await FlutterLocalNotificationsPlugin().showDailyAtTime(
      0,
      'Rappel quotidien',
      "N'oubliez-pas de remplir vos questionnaires aujourd'hui!",
      time,
      platformChannelSpecifics,
    );
  }
}
