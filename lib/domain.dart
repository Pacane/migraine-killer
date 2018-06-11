import 'src/domain/stai.dart' as stai;
import 'src/domain/poms.dart' as poms;

List<String> get staiQuestions => stai.questions;
List<String> get pomsQuestions => poms.questions;

enum Quiz {
  stai,
  poms,
}

class AnswerUpdate {
  final String question;
  final int answer;

  AnswerUpdate(this.question, this.answer);
}
