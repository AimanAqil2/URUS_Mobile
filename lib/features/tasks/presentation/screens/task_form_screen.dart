import 'package:flutter/material.dart';

enum TaskFormMode { create, edit }

/// One route widget for both task creation and editing.
class TaskFormScreen extends StatelessWidget {
  const TaskFormScreen({required this.mode, super.key, this.taskId});

  final TaskFormMode mode;
  final String? taskId;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Text(mode == TaskFormMode.create ? 'Create Task' : 'Edit Task'),
    ),
  );
}
