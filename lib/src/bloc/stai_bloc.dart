import 'package:flutter/widgets.dart';
import 'package:migraine_killer/domain.dart';
import 'quiz_bloc.dart';

class STAIState extends QuizState {
  static const String _collectionName = 'stai';

  STAIState() : super(staiQuestions, _collectionName);

  int get score {
    if (result.entries.any((entry) => entry.value == null)) {
      return -1;
    } else {
      var indicesToReverseAnswers =
          [1, 2, 5, 8, 10, 11, 15, 16, 19, 20].map((index) => index - 1);

      return staiQuestions.fold(0, (score, question) {
        final answer = result[question];

        return indicesToReverseAnswers.contains(staiQuestions.indexOf(question))
            ? score + (5 - answer).abs()
            : score + answer;
      });
    }
  }
}

class STAIBloc extends QuizBloc {
  STAIBloc() : super(STAIState());
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
