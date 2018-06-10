import 'package:flutter/material.dart';
import 'package:migraine_killer/bloc.dart';
import 'package:migraine_killer/domain.dart';

class QuestionWidget extends StatelessWidget {
  final String question;
  final int answer;

  QuestionWidget(this.question, this.answer);

  @override
  Widget build(BuildContext context) {
    final quiz = STAIProvider.of(context);

    void updateAnswer(int value) =>
        quiz.answerSink.add(AnswerUpdate(question, value));

    int questionIndex = questions.indexOf(question);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "${questionIndex + 1}/${quiz.amountOfQuestions}. $question",
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
