import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task.dart';
import '../providers/task_provider.dart';

class DetailTaskScreen extends StatelessWidget {
  final Task task;

  const DetailTaskScreen({super.key, required this.task});

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      context.read<TaskProvider>().deleteTask(task.id);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete task')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Detail')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(task.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(task.isCompleted ? 'Completed' : 'Active'),
            const SizedBox(height: 16),
            Text(
              task.description.isEmpty ? 'No description' : task.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () {
                context.read<TaskProvider>().toggleStatus(task.id);
                Navigator.pop(context);
              },
              icon: Icon(
                task.isCompleted ? Icons.undo : Icons.check,
              ),
              label: Text(
                task.isCompleted ? 'Mark as Active' : 'Mark as Completed',
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _delete(context),
              icon: const Icon(Icons.delete_outline),
              label: const Text('Delete Task'),
            ),
          ],
        ),
      ),
    );
  }
}
