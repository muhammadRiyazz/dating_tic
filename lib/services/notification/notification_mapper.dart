import 'package:dating/services/notification/in_app_notification.dart';

class NotificationMapper {
  static InAppNotification fromFCM(Map<String, dynamic> data) {
    // 1. Fix duplicated URL in senderImage
    String? rawImage = data['senderImage'];
    String? cleanedImage;
    if (rawImage != null) {
      int lastIndex = rawImage.lastIndexOf('http');
      cleanedImage = (lastIndex != -1) ? rawImage.substring(lastIndex) : rawImage;
    }
    
    // 2. Extract specific keys
    String type = (data['type'] ?? 'general').toString().toLowerCase();
    String senderName = (data['senderName'] ?? 'Someone').toString().trim();
    String body = data['body'] ?? 'Tap to view details';
    
    // 3. Create Dynamic Personalized Title
    String title = "";
    switch (type) {
      case 'like':
        title = "$senderName liked you! ❤️";
        break;
      case 'match':
        title = "It's a Match with $senderName! 🔥";
        break;
      case 'message':
        title = "Message from $senderName 💬";
        break;
      default:
        title = data['title'] ?? "New Notification";
    }
    
    return InAppNotification(
      id: data['notificationId']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      title: title,
      body: body,
      senderId: data['senderId']?.toString() ?? '',
      senderName: senderName,
      senderImage: cleanedImage,
      data: data,
      timestamp: DateTime.now(),
    );
  }
}