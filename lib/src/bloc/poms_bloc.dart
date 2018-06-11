import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:migraine_killer/domain.dart';
import 'quiz_bloc.dart';

class POMSState extends QuizState {
  static const String _collectionName = 'poms-sm';

  POMSState() : super(pomsQuestions, _collectionName);

  num get score {
    return result.entries.fold(0, (acc, entry) => acc + entry.value) /
        result.entries.length;
  }

  String dateString(DateTime date) {
    var iso8601string =
        DateTime(date.year, date.month, date.day).toIso8601String();
    return iso8601string;
  }
}

class POMSBloc {
  final POMSState _quiz;

  int get amountOfQuestions => _quiz.amountOfQuestions;

  DateTime get currentDate => _quiz.currentDate;

  List<String> get questions => _quiz.questions;

  set currentDate(DateTime date) => _quiz.updateDate(date);

  Stream<List<AnswerUpdate>> get answers => _quiz.answers;

  Sink<AnswerUpdate> get answerSink => _answersController.sink;

  // ignore: close_sinks
  StreamController<AnswerUpdate> _answersController = StreamController();

  POMSBloc() : _quiz = new POMSState() {
    _answersController.stream.listen((update) {
      _quiz.updateAnswer(update.question, update.answer);
    });
  }

  int indexOfQuestion(String question) => questions.indexOf(question);
}

class POMSProvider extends InheritedWidget {
  final POMSBloc quizBloc;

  POMSProvider({
    Key key,
    POMSBloc quizBloc,
    Widget child,
  })  : quizBloc = quizBloc ?? POMSBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static POMSBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(POMSProvider) as POMSProvider)
          .quizBloc;
}
