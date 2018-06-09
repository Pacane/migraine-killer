import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:migraine_killer/domain.dart';

class STAIState {
  CollectionReference _collection = Firestore.instance.collection('stai');

  DateTime _currentDate = DateTime.now();

  Map<String, int> _questions =
      new Map.fromIterable(questions, value: (_) => null);

  int get score {
    if (_questions.entries.any((entry) => entry.value == null)) {
      return -1;
    } else {
      var indicesToReverseAnswers =
          [1, 2, 5, 8, 10, 11, 15, 16, 19, 20].map((index) => index - 1);

      return questions.fold(0, (score, question) {
        final answer = _questions[question];

        return indicesToReverseAnswers.contains(questions.indexOf(question))
            ? score + (5 - answer).abs()
            : score + answer;
      });
    }
  }

  int get amountOfQuestions => _questions.length;

  Stream<List<AnswerUpdate>> get answers => _collection
      .document(dateString(_currentDate))
      .snapshots()
      .map((DocumentSnapshot s) => s.data == null
          ? _questions.keys.map((q) {
              return AnswerUpdate(q, null);
            }).toList()
          : s.data.keys.map((q) {
              return AnswerUpdate(q, s.data[q]);
            }).toList());

  void updateAnswer(String question, int answer) {
    String iso8601string = dateString(_currentDate);

    _questions[question] = answer;

    _collection.document(iso8601string).setData(_questions, merge: true);
  }

  void updateDate(DateTime date) {
    _currentDate = date;
  }

  String dateString(DateTime date) {
    var iso8601string =
        DateTime(date.year, date.month, date.day).toIso8601String();
    return iso8601string;
  }
}

class STAIBloc {
  final STAIState _quiz;

  int get amountOfQuestions => _quiz.amountOfQuestions;

  DateTime get currentDate => _quiz._currentDate;

  set currentDate(DateTime date) => _quiz.updateDate(date);

  Stream<List<AnswerUpdate>> get answers => _quiz.answers;

  Sink<AnswerUpdate> get answerSink => _answersController.sink;

  // ignore: close_sinks
  StreamController<AnswerUpdate> _answersController = StreamController();

  STAIBloc() : _quiz = new STAIState() {
    _answersController.stream.listen((update) {
      _quiz.updateAnswer(update.question, update.answer);
    });
  }

  int indexOfQuestion(String question) =>
      _quiz._questions.keys.toList().indexOf(question);
}

class STAIProvider extends InheritedWidget {
  final STAIBloc quizBloc;

  STAIProvider({
    Key key,
    STAIBloc quizBloc,
    Widget child,
  })  : quizBloc = quizBloc ?? STAIBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static STAIBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(STAIProvider) as STAIProvider)
          .quizBloc;
}
