import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:migraine_killer/domain.dart';
import 'package:migraine_killer/widgets.dart';

class QuizPage extends StatefulWidget {
  final Function providerFactory;
  final String title;

  QuizPage(
    this.providerFactory,
    this.title,
  );

  @override
  State<StatefulWidget> createState() => QuizState();
}

class QuizState extends State<QuizPage> with TickerProviderStateMixin {
  int currentStepIndex = 0;
  TabController controller;

  StatelessWidget get quizNavigationWidget => Container(
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
                    controller.animateTo(controller.index - 1,
                        duration: Duration(milliseconds: 100));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text('SUIVANT'),
                onPressed: () {
                  if (controller.index < staiQuestions.length - 1) {
                    controller.animateTo(controller.index + 1,
                        duration: Duration(milliseconds: 100));
                  }
                },
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final quiz = widget.providerFactory(context);

    controller = new TabController(
      length: quiz.amountOfQuestions,
      vsync: this,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () async {
              final newDate = await showDatePicker(
                  context: context,
                  initialDate: quiz.currentDate,
                  firstDate: quiz.currentDate.subtract(Duration(days: 30)),
                  lastDate: quiz.currentDate.add(Duration(days: 30)));

              if (newDate != null) {
                setState(() {
                  quiz.currentDate = newDate;
                });
              }
            },
          )
        ],
      ),
      body: StreamBuilder<List<AnswerUpdate>>(
        initialData: [],
        stream: quiz.answers,
        builder: (context, snapshot) {
          if (snapshot.error != null) {
            throw snapshot.error;
          }

          var sortedQuestions = snapshot.data == null ? [] : snapshot.data
            ..sort((a1, a2) => quiz
                .indexOfQuestion(a1.question)
                .compareTo(quiz.indexOfQuestion(a2.question)));

          return sortedQuestions.isEmpty
              ? Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: controller,
                  children: sortedQuestions
                      .map((update) => Column(
                            children: <Widget>[
                              QuestionWidget(
                                update.question,
                                update.answer,
                                widget.providerFactory,
                              ),
                              quizNavigationWidget,
                            ],
                          ))
                      .toList(),
                );
        },
      ),
    );
  }
}
