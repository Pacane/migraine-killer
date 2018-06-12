import 'package:flutter/widgets.dart';
import 'package:migraine_killer/domain.dart';
import 'quiz_bloc.dart';

class POMSState extends QuizState {
  static const String _collectionName = 'poms-sm';

  POMSState() : super(pomsQuestions, _collectionName);

  num get score => result.entries.any((entry) => entry.value == null)
      ? -1
      : result.entries.fold(0, (acc, entry) => acc + entry.value) /
          result.entries.length;
}

class POMSBloc extends QuizBloc {
  POMSBloc() : super(POMSState());
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
