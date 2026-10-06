import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatelessWidget {
  const TaskDetailsScreen({super.key, this.taskId});

  final String? taskId;

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Task Details')));
}
