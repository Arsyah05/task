class Task {
  final int id;
  final String name;
  final String description;
  bool isCompleted;

  Task({
    required this.id,
    required this.name,
    this.description = '',
    this.isCompleted = false,
  });
}
