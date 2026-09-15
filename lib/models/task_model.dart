class TaskModel {
  final String?  id;
  final String   userId;
  final String   title;
  final String   description;
  final String   priority;     
  final DateTime dueDate;
  final String   startTime;
  final String   endTime;
  final bool     isCompleted;
  final int      points;

  TaskModel({
    this.id,
    required this.userId,
    required this.title,
    this.description = '',
    this.priority    = 'medium',
    required this.dueDate,
    this.startTime   = '',
    this.endTime     = '',
    this.isCompleted = false,
    this.points      = 10,
  });
}
