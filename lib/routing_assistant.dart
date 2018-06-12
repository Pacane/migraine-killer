import 'package:flutter/material.dart';
import 'package:migraine_killer/bloc.dart';
import 'package:migraine_killer/pages.dart';

class RoutingAssistant {
  static MaterialPageRoute staiPage() => MaterialPageRoute(
        builder: (_) => STAIProvider(
              child: QuizPage(
                (BuildContext context) => STAIProvider.of(context),
                'STAI-Y',
              ),
            ),
      );

  static MaterialPageRoute pomsPage() => MaterialPageRoute(
        builder: (_) => POMSProvider(
              child: QuizPage(
                (BuildContext context) => POMSProvider.of(context),
                'POMS-SM',
              ),
            ),
      );
}
