enum NotificationType { credit, order, payment }

class AppNotification {
  final String message;
  final DateTime timestamp;
  final NotificationType type;

  AppNotification({
    required this.message,
    required this.timestamp,
    required this.type,
  });
}