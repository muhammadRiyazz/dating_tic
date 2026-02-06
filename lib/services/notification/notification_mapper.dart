import 'package:dating/services/notification/in_app_notification.dart';

class NotificationMapper {
  static InAppNotification fromFCM(Map<String, dynamic> data) {
    // 1. Fix duplicated/Nested URL in senderImage
    String? rawImage = data['senderImage']?.toString();
    String? cleanedImage;
    if (rawImage != null && rawImage.isNotEmpty) {
      // Find the last occurrence of http to handle nested URLs
      int lastIndex = rawImage.lastIndexOf('http');
      cleanedImage = (lastIndex != -1) ? rawImage.substring(lastIndex) : rawImage;
    }
    
    // 2. Extract and Normalize keys
    String type = (data['type'] ?? 'general').toString().toLowerCase();
    String senderName = (data['senderName'] ?? 'Someone').toString().trim();
    String body = (data['body'] ?? data['message'] ?? 'New activity on your profile').toString();
    String rawTitle = (data['title'] ?? '').toString();
    
    // 3. Create Dynamic Personalized Title
    String title = "";
    if (rawTitle.isNotEmpty && !rawTitle.contains('Match')) {
       title = rawTitle;
    } else {
      switch (type) {
        case 'like':
          title = "$senderName liked you! ❤️";
          break;
        case 'match':
          title = "It's a Match with $senderName! 🎉";
          break;
        case 'message':
          title = "Message from $senderName 💬";
          break;
        default:
          title = rawTitle.isNotEmpty ? rawTitle : "New Notification";
      }
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