import 'package:flutter/material.dart';
import 'package:migraine_killer/pages.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Migraine Killer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MenuPage(),
      );
}
