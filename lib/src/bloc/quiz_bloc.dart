import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:migraine_killer/domain.dart';

abstract class QuizState {
  final String _collectionName;
  final List<String> questions;

  DateTime currentDate = DateTime.now();

  final Map<String, int> result;

  QuizState(List<String> questions, this._collectionName)
      : result = Map.fromIterable(questions, value: (_) => null),
        this.questions = questions;

  num get score;

  int get amountOfQuestions => questions.length;

  CollectionReference get collection =>
      Firestore.instance.collection(_collectionName);

  Stream<List<AnswerUpdate>> get answers => collection
      .document(dateString(currentDate))
      .snapshots()
      .map((DocumentSnapshot s) => s.data == null
          ? result.keys.map((q) {
              return AnswerUpdate(q, null);
            }).toList()
          : s.data.keys.map((q) {
              return AnswerUpdate(q, s.data[q]);
            }).toList());

  void updateAnswer(String question, int answer) {
    String iso8601string = dateString(currentDate);

    result[question] = answer;

    collection.document(iso8601string).setData(result, merge: true);
  }

  void updateDate(DateTime date) {
    currentDate = date;
  }

  String dateString(DateTime date) {
    var iso8601string =
        DateTime(date.year, date.month, date.day).toIso8601String();
    return iso8601string;
  }
}

class QuizBloc {
  final QuizState _quiz;

  int get amountOfQuestions => _quiz.amountOfQuestions;

  List<String> get questions => _quiz.questions;

  DateTime get currentDate => _quiz.currentDate;

  set currentDate(DateTime date) => _quiz.updateDate(date);

  Stream<List<AnswerUpdate>> get answers => _quiz.answers;

  Sink<AnswerUpdate> get answerSink => _answersController.sink;

  // ignore: close_sinks
  StreamController<AnswerUpdate> _answersController = StreamController();

  QuizBloc(QuizState quiz) : _quiz = quiz {
    _answersController.stream.listen((update) {
      _quiz.updateAnswer(update.question, update.answer);
    });
  }

  int indexOfQuestion(String question) => questions.indexOf(question);
}
