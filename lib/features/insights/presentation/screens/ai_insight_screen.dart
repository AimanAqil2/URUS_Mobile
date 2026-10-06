import 'package:flutter/material.dart';

class AiInsightScreen extends StatelessWidget {
  const AiInsightScreen({super.key, this.taskId});

  final String? taskId;

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('AI Insight')));
}
