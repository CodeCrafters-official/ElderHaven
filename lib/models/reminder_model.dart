// File: lib/models/reminder_model.dart

class Reminder {
  final String title;
  final String description;
  final DateTime dateTime;

  Reminder({required this.title, required this.description, required this.dateTime});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      title: map['title'],
      description: map['description'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }
}
