import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  int currentStepIndex = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Stepper(
          currentStep: currentStepIndex,
          onStepContinue: () => setState(() => currentStepIndex++),
          onStepTapped: (int index) => setState(() => currentStepIndex = index),
          steps: [
            Step(
              title: Text('Étape 1'),
              content: Text('Hey 1'),
            ),
            Step(
              title: Text('Étape 2'),
              content: Text('Étape 2!'),
            ),
          ],
        ),
      );
}
