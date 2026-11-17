import 'package:flutter/foundation.dart';

import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = [
    Task(
      id: 1,
      name: 'Mengerjakan tugas kuliah',
      description: 'Menyelesaikan tugas mata kuliah minggu ini.',
    ),
    Task(
      id: 2,
      name: 'Membaca materi pemrograman',
      description: 'Membaca materi pemrograman bab 5.',
      isCompleted: true,
    ),
    Task(
      id: 3,
      name: 'Membuat laporan praktikum',
      description: 'Menyusun laporan praktikum PPB.',
    ),
    Task(
      id: 4,
      name: 'Belajar Flutter',
      description: 'Mempelajari dasar-dasar Flutter dan Provider.',
      isCompleted: true,
    ),
    Task(
      id: 5,
      name: 'Menyelesaikan project',
      description: 'Menyelesaikan project aplikasi Task.',
    ),
  ];

  int _nextId = 6;

  List<Task> get tasks => _tasks;

  int get totalCount => _tasks.length;

  int get completedCount => _tasks.where((task) => task.isCompleted).length;

  void addTask(String name, String description) {
    _tasks.add(
      Task(id: _nextId++, name: name, description: description),
    );
    notifyListeners();
  }

  void toggleStatus(int id) {
    final task = _tasks.firstWhere((task) => task.id == id);
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  void deleteTask(int id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
