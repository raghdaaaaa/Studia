import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final DateTime date;
  final String time;
  final bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.isCompleted,
  });

  factory TaskModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'medium',
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  /// Minutes since midnight for ordering; supports "10:30 AM" and "14:30".
  int get timeMinutes {
    final match =
        RegExp(r'^(\d{1,2}):(\d{2})\s*(AM|PM)?$').firstMatch(time.trim());
    if (match == null) return 0;

    var hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3);

    if (period == 'AM' && hour == 12) hour = 0;
    if (period == 'PM' && hour != 12) hour += 12;

    return hour * 60 + minute;
  }
}