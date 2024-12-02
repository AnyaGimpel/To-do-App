import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a task with details like title, description, and completion status.
class Task {
  String userId;
  String id;
  String title;
  String description;
  DateTime dateTime;
  bool isCompleted;

  /// Constructor to create a [Task] object.
  Task({
    required this.userId,
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.isCompleted,
  });

  /// Factory method to create a [Task] object from a Firestore document.
  ///
  /// [data] is the document data from Firestore, and [id] is the document ID.
  factory Task.fromFirestore(Map<String, dynamic> data, String id) {
    return Task(
      id: id,
      userId: data['userId'],
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      isCompleted: data['isCompleted'] ?? false,
    );
  }
}
