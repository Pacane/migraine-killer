import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Migraine Killer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: QuizProvider(child: MyHomePage(title: 'STAI-POMS')),
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

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int currentStepIndex = 0;
  TabController controller;

  @override
  Widget build(BuildContext context) {
    final quiz = QuizProvider.of(context);
    controller = new TabController(
      length: quiz.amountOfQuestions,
      vsync: this,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<AnswerUpdate>>(
        initialData: [],
        stream: quiz.answers,
        builder: (context, snapshot) => TabBarView(
              controller: controller,
              children: snapshot.data
                  .map((update) => Column(
                        children: <Widget>[
                          QuestionWidget(update.question, update.answer),
                          Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    child: Text('PRÉCÉDENT'),
                                    onPressed: () {
                                      if (controller.index > 0) {
                                        controller.animateTo(
                                            controller.index - 1,
                                            duration:
                                                Duration(milliseconds: 100));
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    child: Text('SUIVANT'),
                                    onPressed: () {
                                      if (controller.index <
                                          snapshot.data.length - 1) {
                                        controller.animateTo(
                                            controller.index + 1,
                                            duration:
                                                Duration(milliseconds: 100));
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                  .toList(),
            ),
      ),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final String question;
  final int answer;

  QuestionWidget(this.question, this.answer);

  @override
  Widget build(BuildContext context) {
    final quiz = QuizProvider.of(context);

    void updateAnswer(int value) =>
        quiz.answerSink.add(new AnswerUpdate(question, value));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              question,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          new RadioListTile(
            title: Text(
              'Pas du tout',
              softWrap: true,
            ),
            groupValue: answer,
            value: 1,
            onChanged: updateAnswer,
          ),
          RadioListTile<int>(
            title: Text('Un peu'),
            groupValue: answer,
            value: 2,
            onChanged: updateAnswer,
          ),
          RadioListTile<int>(
            title: Text('Modérément'),
            groupValue: answer,
            value: 3,
            onChanged: updateAnswer,
          ),
          RadioListTile<int>(
            title: Text('Beaucoup'),
            groupValue: answer,
            value: 4,
            onChanged: updateAnswer,
          ),
        ],
      ),
    );
  }
}

class AnswerUpdate {
  final String question;
  final int answer;

  AnswerUpdate(this.question, this.answer);
}

class QuizState {
  Map<String, int> _questions = {
    "Je me sens calme": null,
    "Je me sens en sécurité": null,
    "Je suis tendu(e)": null,
    "Je me sens surmené(e)": null,
    "Je me sens tranquille": null,
    "Je me sens bouleversé": null,
    "Je suis préoccupé(e) actuellement par des malheurs possibles": null,
    "Je me sens comblé(e)": null,
    "Je me sens effrayé(e)": null,
    "Je me sens à l’aise": null,
    "Je me sens sûr de moi": null,
    "Je me sens nerveux(se)": null,
    "Je suis affolé(e)": null,
    "Je me sens indécis(e)": null,
    "Je suis détendu(e)": null,
    "Je me sens satisfait(e)": null,
    "Je suis préoccupé(e)": null,
    "Je me sens tout mêlé(e)": null,
    "Je sens que j’ai les nerfs solides": null,
    "Je me sens bien": null,
  };

  int get amountOfQuestions => _questions.length;

  Stream<List<AnswerUpdate>> get answers => Firestore.instance
          .collection('stai-poms')
          .document(nowDate())
          .snapshots()
          .map((DocumentSnapshot s) {
        if (s.data == null) {
          return _questions.keys.map((q) => AnswerUpdate(q, null)).toList();
        }

        return s.data.keys.map((q) => AnswerUpdate(q, s.data[q])).toList();
      });

  void updateAnswer(String question, int answer) {
    final collection = Firestore.instance.collection('stai-poms');
    String iso8601string = nowDate();

    _questions[question] = answer;

    collection.document(iso8601string).setData(_questions, merge: true);
  }

  String nowDate() {
    final now = DateTime.now();
    var iso8601string =
        DateTime(now.year, now.month, now.day).toIso8601String();
    return iso8601string;
  }
}

class QuizBloc {
  final QuizState _quiz;

  int get amountOfQuestions => _quiz.amountOfQuestions;

  Stream<List<AnswerUpdate>> get answers => _quiz.answers;

  Sink<AnswerUpdate> get answerSink => _controller.sink;

  // ignore: close_sinks
  StreamController<AnswerUpdate> _controller = StreamController();

  QuizBloc() : _quiz = new QuizState() {
    _controller.stream.listen((update) {
      _quiz.updateAnswer(update.question, update.answer);
    });
  }
}

class QuizProvider extends InheritedWidget {
  final QuizBloc quizBloc;

  QuizProvider({
    Key key,
    QuizBloc quizBloc,
    Widget child,
  })  : quizBloc = quizBloc ?? QuizBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static QuizBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(QuizProvider) as QuizProvider)
          .quizBloc;
}
