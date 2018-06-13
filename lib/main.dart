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

    _scheduleReminderNotification();
  }

  Future _scheduleReminderNotification() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'mk_001',
      'reminder_night',
      'quiz reminder night',
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
      Time(22),
      platformChannelSpecifics,
    );
  }
}
