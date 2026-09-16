import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Models/task_model.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createTask({
    required String title,
    required String description,
    required String category,
    required DateTime date,
    required String time,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    await _firestore.collection('tasks').add({
      'userId': user.uid,
      'title': title,
      'description': description,
      'category': category,
      'date': Timestamp.fromDate(date),
      'time': time,
      'isCompleted': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateTask({
    required String taskId,
    required String title,
    required String description,
    required String category,
    required DateTime date,
    required String time,
  }) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'title': title,
      'description': description,
      'category': category,
      'date': Timestamp.fromDate(date),
      'time': time,
    });
  }

  Future<void> updateTaskCompletion({
    required String taskId,
    required bool isCompleted,
  }) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'isCompleted': isCompleted,
    });
  }

  Future<void> deleteTask(String taskId) async {
    await _firestore.collection('tasks').doc(taskId).delete();
  }

  Stream<List<TaskModel>> getTasks() {
    final user = _auth.currentUser;

    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TaskModel.fromFirestore(doc))
              .toList()
            ..sort((a, b) {
              final dateCompare = a.date.compareTo(b.date);
              if (dateCompare != 0) return dateCompare;
              return a.timeMinutes.compareTo(b.timeMinutes);
            }),
        );
  }
}
