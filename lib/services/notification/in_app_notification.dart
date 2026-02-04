class InAppNotification {
  final String id;
  final String type; // like, match, message, view
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final String senderId;
  final String senderName;
  final String? senderImage;
  final DateTime timestamp;

  InAppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.senderId,
    required this.senderName,
    this.senderImage,
    required this.timestamp,
  });
}