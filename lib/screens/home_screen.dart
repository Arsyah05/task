import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import 'about_screen.dart';
import 'add_task_screen.dart';
import 'detail_task_screen.dart';

enum TaskFilter { all, active, completed }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  TaskFilter _filter = TaskFilter.all;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _summary(String label, int count) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('$count', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final tasks = provider.tasks.where((task) {
      final matchesSearch =
          task.name.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = switch (_filter) {
        TaskFilter.all => true,
        TaskFilter.active => !task.isCompleted,
        TaskFilter.completed => task.isCompleted,
      };
      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              _summary('Total Tasks', provider.totalCount),
              const SizedBox(width: 12),
              _summary('Completed', provider.completedCount),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Search tasks',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<TaskFilter>(
            segments: const [
              ButtonSegment(value: TaskFilter.all, label: Text('All')),
              ButtonSegment(value: TaskFilter.active, label: Text('Active')),
              ButtonSegment(
                value: TaskFilter.completed,
                label: Text('Completed'),
              ),
            ],
            selected: {_filter},
            onSelectionChanged: (selection) {
              setState(() => _filter = selection.first);
            },
          ),
          const SizedBox(height: 16),
          if (tasks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: Center(
                child: Text(
                  provider.tasks.isEmpty
                      ? 'No tasks yet. Tap + to add a task.'
                      : 'No tasks found.',
                ),
              ),
            )
          else
            ...tasks.map(
              (task) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    task.isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: task.isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                  title: Text(
                    task.name,
                    style: task.isCompleted
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough,
                          )
                        : null,
                  ),
                  subtitle: Text(task.isCompleted ? 'Completed' : 'Active'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailTaskScreen(task: task),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
