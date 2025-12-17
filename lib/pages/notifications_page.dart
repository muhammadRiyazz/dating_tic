import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NotificationsPage extends StatelessWidget {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Match!',
      'message': 'You and Mia have liked each other',
      'time': 'Just now',
      'icon': Iconsax.heart5,
      'color': Colors.red,
      'read': false,
    },
    {
      'title': 'Message Received',
      'message': 'Sophia sent you a message',
      'time': '10 min ago',
      'icon': Iconsax.message_text5,
      'color': Colors.blue,
      'read': false,
    },
    {
      'title': 'Profile Viewed',
      'message': 'Your profile was viewed 15 times today',
      'time': '1 hour ago',
      'icon': Iconsax.eye,
      'color': Colors.green,
      'read': true,
    },
  
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryRed = const Color(0xFFFF3B30);
    final backgroundColor = isDark ? const Color(0xFF0A0505) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final hintColor = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_2, color: primaryRed),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            
            const SizedBox(height: 24),
            
            // Today
            Text(
              'Today',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            // Notification List
            ..._notifications.where((n) => n['time'].contains('now') || n['time'].contains('ago')).map((notification) {
              return _buildNotificationItem(notification, isDark, primaryRed, textColor, hintColor);
            }).toList(),
            
            const SizedBox(height: 24),
            
            // Earlier
            Text(
              'Earlier',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            ..._notifications.where((n) => n['time'].contains('day')).map((notification) {
              return _buildNotificationItem(notification, isDark, primaryRed, textColor, hintColor);
            }).toList(),
            
            const SizedBox(height: 40),
            
            // Notification Settings
            GestureDetector(
              onTap: () {
                // Navigate to notification settings
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade900.withOpacity(0.5) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.setting_2,
                      color: primaryRed,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Notification Settings',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Iconsax.arrow_right_3,
                      color: hintColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(
    Map<String, dynamic> notification,
    bool isDark,
    Color primaryRed,
    Color textColor,
    Color hintColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark 
            ? (notification['read'] ? Colors.grey.shade900.withOpacity(0.3) : Colors.blue.shade900.withOpacity(0.2))
            : (notification['read'] ? Colors.grey.shade100 : Colors.blue.shade50),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification['read'] 
              ? Colors.transparent 
              : primaryRed.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: notification['color'].withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              notification['icon'],
              color: notification['color'],
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      notification['title'],
                      style: TextStyle(
                        color: textColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      notification['time'],
                      style: TextStyle(
                        color: hintColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification['message'],
                  style: TextStyle(
                    color: hintColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (!notification['read'])
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: primaryRed,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}