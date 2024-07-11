// notification_model.dart
class NotificationModel {
  final String title;
  final String description;
  final DateTime timestamp;

  NotificationModel({required this.title, required this.description, required this.timestamp});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
