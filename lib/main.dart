import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:migraine_killer/bloc.dart';
import 'package:migraine_killer/domain.dart';
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
        home: STAIProvider(
          child: MyHomePage(title: 'STAI-POMS'),
        ),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Quiz _currentQuiz = Quiz.stai;

  @override
  Widget build(BuildContext context) {
    return STAIPage();
  }
}
