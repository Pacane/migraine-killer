import 'package:flutter/material.dart';
import 'package:migraine_killer/bloc.dart';
import 'package:migraine_killer/pages.dart';

class RoutingAssistant {
  static MaterialPageRoute staiPage() => MaterialPageRoute(
        builder: (_) => STAIProvider(child: STAIPage()),
      );

  static MaterialPageRoute pomsPage() => MaterialPageRoute(
        builder: (_) => STAIPage(), // TODO POMS page
      );
}
