import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Migraine Killer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'STAI-POMS'),
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

  List<String> questions = [
    "Je me sens calme.",
    "Je me sens en sécurité.",
    "Je suis tendu(e).",
    "Je me sens surmené(e)",
    "Je me sens tranquille.",
    "Je me sens bouleversé.",
    "Je suis préoccupé(e) actuellement par des malheurs possibles.",
    "Je me sens comblé(e).",
    "Je me sens effrayé(e).",
    "Je me sens à l’aise.",
    "Je me sens sûr de moi.",
    "Je me sens nerveux(se).",
    "Je suis affolé(e).",
    "Je me sens indécis(e).",
    "Je suis détendu(e).",
    "Je me sens satisfait(e).",
    "Je suis préoccupé(e).",
    "Je me sens tout mêlé(e).",
    "Je sens que j’ai les nerfs solides.",
    "Je me sens bien.",
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Stepper(
          currentStep: currentStepIndex,
          onStepContinue: () => setState(() => currentStepIndex++),
          onStepTapped: (int index) => setState(() => currentStepIndex = index),
          steps: questions
              .map((String q) => Step(
                    title: Text(
                      q,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    content: QuestionWidget(),
                  ))
              .toList(),
        ),
      );
}

class QuestionWidget extends StatefulWidget {
  QuestionWidget();

  @override
  State<StatefulWidget> createState() => QuestionWidgetState();
}

class QuestionWidgetState extends State<QuestionWidget> {
  int answer;

  QuestionWidgetState();

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          new RadioListTile(
            title: Text(
              'Pas du tout',
              softWrap: true,
            ),
            groupValue: answer,
            value: 1,
            onChanged: (newValue) {
              setState(() {
                answer = newValue;
              });
            },
          ),
          RadioListTile<int>(
            title: Text('Un peu'),
            groupValue: answer,
            value: 2,
            onChanged: (newValue) {
              setState(() {
                answer = newValue;
              });
            },
          ),
          RadioListTile<int>(
            title: Text('Modérément'),
            groupValue: answer,
            value: 3,
            onChanged: (newValue) {
              setState(() {
                answer = newValue;
              });
            },
          ),
          RadioListTile<int>(
            title: Text('Beaucoup'),
            groupValue: answer,
            value: 4,
            onChanged: (newValue) {
              setState(() {
                answer = newValue;
              });
            },
          ),
        ],
      );
}
