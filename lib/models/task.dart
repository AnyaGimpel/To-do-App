import 'package:cloud_firestore/cloud_firestore.dart';

class Task{
  String userId;
  String id;
  String title;
  String description;
  DateTime dateTime;
  bool isCompleted;

  Task({
    required this.userId,
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.isCompleted
  });

  // Создание объекта из документа Firestore
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