import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:migraine_killer/bloc.dart';
import 'package:migraine_killer/domain.dart' as stai_poms;
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Migraine Killer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: STAIProvider(child: MyHomePage(title: 'STAI-POMS')),
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
    final quiz = STAIProvider.of(context);
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


              var documents = await Firestore.instance.collection('stai-poms').getDocuments();
              var docs = documents.documents;

              for (var doc in docs) {
                await Firestore.instance.collection('stai').document(doc.documentID.split('/').last).setData(doc.data, merge: true);
              }

              if (newDate != null) {
                setState(() {
                  quiz.currentDate = newDate;
                });
              }
            },
          )
        ],
      ),
      body: StreamBuilder<List<stai_poms.AnswerUpdate>>(
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
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.highlight_off,
                        size: 128.0,
                      ),
                      Text('Oh no!', style: TextStyle(fontSize: 48.0),),
                    ],
                  ),
                )
              : TabBarView(
                  controller: controller,
                  children: sortedQuestions
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
                                                duration: Duration(
                                                    milliseconds: 100));
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
                                              sortedQuestions.length - 1) {
                                            controller.animateTo(
                                                controller.index + 1,
                                                duration: Duration(
                                                    milliseconds: 100));
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
                );
        },
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
    final quiz = STAIProvider.of(context);

    void updateAnswer(int value) =>
        quiz.answerSink.add(new stai_poms.AnswerUpdate(question, value));

    int questionIndex = stai_poms.questions.indexOf(question);

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
