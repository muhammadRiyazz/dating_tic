
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:dating/core/url.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  
  static String? _fcmToken;
  static bool _isInitialized = false;
  
  // Stream for token updates
  static final StreamController<String> _tokenController = StreamController<String>.broadcast();
  static Stream<String> get tokenStream => _tokenController.stream;
  
  // Stream for notification events
  static final StreamController<Map<String, dynamic>> _notificationController = 
      StreamController<Map<String, dynamic>>.broadcast();
  static Stream<Map<String, dynamic>> get notificationStream => _notificationController.stream;

  static Future<void> init() async {
    if (_isInitialized) {
      log("✅ Notifications already initialized");
      return;
    }
    
    try {
      log("🚀 Initializing notifications...");
      
      // 1. Request permissions
      await _requestPermissions();
      
      // 2. Initialize local notifications
      await _initializeLocalNotifications();
      
      // 3. Set up notification handlers
      await _setupNotificationHandlers();
      
      // 4. Listen for token refresh
      _setupTokenRefreshListener();
      
      // 5. Try to get existing token
      await _tryGetExistingToken();
      
      _isInitialized = true;
      log("✅ Firebase notifications initialized");
      
    } catch (e) {
      log("❌ Notification init error: $e");
    }
  }

  Future<bool> updateFCMTokenToServer(String userId) async {
    if (_fcmToken == null || _fcmToken!.isEmpty) {
      // Try to get token
      await _tryGetExistingToken();
      if (_fcmToken == null) {
        log("⚠️ No FCM token available");
        return false;
      }
    }

    try {
      log("📤 Updating FCM token for user: $userId");
      
      final response = await http.post(
        Uri.parse("$baseUrl/update-notification-fcm"),
        body: {
          'userId': userId,
          'notificationFcm': _fcmToken!,
        },
      ).timeout(const Duration(seconds: 10));

      log("FCM Update Response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'SUCCESS' && jsonResponse['statusCode'] == 0) {
          log("✅ FCM token updated successfully");
          return true;
        } else {
          log("❌ FCM update API failed: ${jsonResponse['statusDesc']}");
          return false;
        }
      } else {
        log("❌ FCM update HTTP error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log("❌ Error updating FCM token: $e");
      return false;
    }
  }

  static Future<void> _requestPermissions() async {
    try {
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: true,
      );
      
      log("📱 Permission status: ${settings.authorizationStatus}");
      
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await _fcm.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      log("❌ Permission error: $e");
    }
  }

  static Future<void> _initializeLocalNotifications() async {
    try {
      // Android setup
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // iOS setup
      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notificationsPlugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (response) {
          log("🎯 Local notification clicked: ${response.payload}");
          try {
            if (response.payload != null) {
              final data = json.decode(response.payload!);
              _notificationController.add({
                'type': 'local_click',
                'data': data,
                'timestamp': DateTime.now(),
              });
            }
          } catch (e) {
            log("Error parsing notification payload: $e");
          }
        },
      );
      
      log("✅ Local notifications ready");
    } catch (e) {
      log("❌ Local notification error: $e");
    }
  }

  static Future<void> _setupNotificationHandlers() async {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("📱 Foreground message received");
      log("Title: ${message.notification?.title}");
      log("Body: ${message.notification?.body}");
      log("Data: ${message.data}");
      
      // _showLocalNotification(message);
      
      _notificationController.add({
        'type': 'foreground',
        'title': message.notification?.title,
        'body': message.notification?.body,
        'data': message.data,
        'timestamp': DateTime.now(),
      });
    });

    // When app opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("📱 App opened from notification");
      
      _notificationController.add({
        'type': 'opened',
        'data': message.data,
        'timestamp': DateTime.now(),
      });
    });

    // Initial notification when app launched from terminated state
    try {
      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        log("📱 Initial notification from terminated state");
        _notificationController.add({
          'type': 'opened',
          'data': initialMessage.data,
          'timestamp': DateTime.now(),
        });
      }
    } catch (e) {
      log("❌ Initial message error: $e");
    }
  }

  static void _setupTokenRefreshListener() {
    _fcm.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      log("🔄 NEW TOKEN RECEIVED: $newToken");
      _tokenController.add(newToken);
    });
  }

  static Future<void> _tryGetExistingToken() async {
    try {
      String? token = await _fcm.getToken();
      if (token != null && token.isNotEmpty) {
        _fcmToken = token;
        log("✅ Existing FCM Token: $token");
        _tokenController.add(token);
      } else {
        log("📱 No existing token found");
      }
    } catch (e) {
      log("⚠️ Token retrieval error: $e");
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'dating_channel',
        'Dating Notifications',
        channelDescription: 'Notifications for dating app',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        colorized: true,
        color: Colors.pink,
      );

      const DarwinNotificationDetails iosDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        message.notification?.title ?? 'New Notification',
        message.notification?.body ?? '',
        platformDetails,
        payload: json.encode(message.data),
      );
    } catch (e) {
      log("❌ Notification show error: $e");
    }
  }

  // ========== PUBLIC METHODS ==========

  static Future<String?> getToken({bool retry = false}) async {
    if (retry || _fcmToken == null) {
      await _tryGetExistingToken();
    }
    return _fcmToken;
  }

  static Future<void> showTestNotification() async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'dating_channel',
        'Dating Notifications',
        channelDescription: 'Test notification',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        colorized: true,
        color: Colors.blue,
      );

      const DarwinNotificationDetails iosDetails =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.show(
        999,
        'Test Notification',
        'This is a test notification',
        platformDetails,
        payload: 'test_${DateTime.now().millisecondsSinceEpoch}',
      );
      
      log("✅ Test notification shown");
    } catch (e) {
      log("❌ Test notification error: $e");
    }
  }

  static Future<void> debugDiagnostics() async {
    log("\n🔍 NOTIFICATION DIAGNOSTICS 🔍");
    log("Platform: ${defaultTargetPlatform}");
    log("Current Token: $_fcmToken");
    
    try {
      final settings = await _fcm.getNotificationSettings();
      log("Permissions: ${settings.authorizationStatus}");
      log("Alert: ${settings.alert}");
      log("Badge: ${settings.badge}");
      log("Sound: ${settings.sound}");
      
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        final apnsToken = await _fcm.getAPNSToken();
        log("APNs Token: $apnsToken");
      }
    } catch (e) {
      log("Diagnostics error: $e");
    }
    log("🔍 END DIAGNOSTICS 🔍\n");
  }

  static void dispose() {
    _tokenController.close();
    _notificationController.close();
  }
}


// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'package:dating/core/url.dart';
// import 'package:http/http.dart' as http;
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class FirebaseNotificationService {
//   static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
  
//   static String? _fcmToken;
//   static bool _isInitialized = false;
  
//   // Stream for token updates
//   static final StreamController<String> _tokenController = StreamController<String>.broadcast();
//   static Stream<String> get tokenStream => _tokenController.stream;
  
//   // Stream for notification events
//   static final StreamController<Map<String, dynamic>> _notificationController = 
//       StreamController<Map<String, dynamic>>.broadcast();
//   static Stream<Map<String, dynamic>> get notificationStream => _notificationController.stream;

//   static Future<void> init() async {
//     if (_isInitialized) {
//       log("✅ Notifications already initialized");
//       return;
//     }
    
//     try {
//       log("🚀 Initializing notifications...");
      
//       // 1. Request permissions
//       await _requestPermissions();
      
//       // 2. Initialize local notifications
//       await _initializeLocalNotifications();
      
//       // 3. Set up notification handlers
//       await _setupNotificationHandlers();
      
//       // 4. Listen for token refresh
//       _setupTokenRefreshListener();
      
//       // 5. Try to get existing token
//       await _tryGetExistingToken();
      
//       _isInitialized = true;
//       log("✅ Firebase notifications initialized");
      
//     } catch (e) {
//       log("❌ Notification init error: $e");
//     }
//   }

//   Future<bool> updateFCMTokenToServer(String userId) async {
//     if (_fcmToken == null || _fcmToken!.isEmpty) {
//       // Try to get token
//       await _tryGetExistingToken();
//       if (_fcmToken == null) {
//         log("⚠️ No FCM token available");
//         return false;
//       }
//     }

//     try {
//       log("📤 Updating FCM token for user: $userId");
      
//       final response = await http.post(
//         Uri.parse("$baseUrl/update-notification-fcm"),
//         body: {
//           'userId': userId,
//           'notificationFcm': _fcmToken!,
//         },
//       ).timeout(const Duration(seconds: 10));

//       log("FCM Update Response: ${response.statusCode} - ${response.body}");

//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//         if (jsonResponse['status'] == 'SUCCESS' && jsonResponse['statusCode'] == 0) {
//           log("✅ FCM token updated successfully");
//           return true;
//         } else {
//           log("❌ FCM update API failed: ${jsonResponse['statusDesc']}");
//           return false;
//         }
//       } else {
//         log("❌ FCM update HTTP error: ${response.statusCode}");
//         return false;
//       }
//     } catch (e) {
//       log("❌ Error updating FCM token: $e");
//       return false;
//     }
//   }

//   static Future<void> _requestPermissions() async {
//     try {
//       final settings = await _fcm.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         provisional: false, // Changed from true to false for explicit permission
//         announcement: false,
//         carPlay: false,
//         criticalAlert: false,
//       );
      
//       log("📱 Permission status: ${settings.authorizationStatus}");
      
//       if (defaultTargetPlatform == TargetPlatform.iOS) {
//         await _fcm.setForegroundNotificationPresentationOptions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//       }
//     } catch (e) {
//       log("❌ Permission error: $e");
//     }
//   }

//   static Future<void> _initializeLocalNotifications() async {
//     try {
//       // Android setup
//       const AndroidInitializationSettings androidSettings =
//           AndroidInitializationSettings('@mipmap/ic_launcher');
      
//       // iOS setup
//       const DarwinInitializationSettings iosSettings =
//           DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//         // onDidReceiveLocalNotification: (id, title, body, payload) {
//         //   log("📱 iOS local notification received");
//         // },
//       );

//       const InitializationSettings settings = InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//       );

//       await _notificationsPlugin.initialize(
//         settings,
//         onDidReceiveNotificationResponse: (response) {
//           log("🎯 Local notification clicked");
//           try {
//             if (response.payload != null) {
//               final data = json.decode(response.payload!);
//               _notificationController.add({
//                 'type': 'local_click',
//                 'data': data,
//                 'timestamp': DateTime.now(),
//               });
//             }
//           } catch (e) {
//             log("Error parsing notification payload: $e");
//           }
//         },
//         onDidReceiveBackgroundNotificationResponse: (response) {
//           log("🌙 Background notification clicked");
//         },
//       );
      
//       log("✅ Local notifications ready");
//     } catch (e) {
//       log("❌ Local notification error: $e");
//     }
//   }

//   static Future<void> _setupNotificationHandlers() async {
//     // Foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       log("📱 Foreground message received");
//       log("Title: ${message.notification?.title}");
//       log("Body: ${message.notification?.body}");
//       log("Data: ${message.data}");
      
//       // Always show local notification as backup
//       await _showLocalNotification(message);
      
//       // Add to notification stream
//       _notificationController.add({
//         'type': 'foreground',
//         'title': message.notification?.title,
//         'body': message.notification?.body,
//         'data': message.data,
//         'timestamp': DateTime.now(),
//       });
//     });

//     // When app opened from notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       log("📱 App opened from notification");
      
//       _notificationController.add({
//         'type': 'opened',
//         'data': message.data,
//         'timestamp': DateTime.now(),
//       });
//     });

//     // Initial notification when app launched from terminated state
//     try {
//       RemoteMessage? initialMessage = await _fcm.getInitialMessage();
//       if (initialMessage != null) {
//         log("📱 Initial notification from terminated state");
//         _notificationController.add({
//           'type': 'opened',
//           'data': initialMessage.data,
//           'timestamp': DateTime.now(),
//         });
//       }
//     } catch (e) {
//       log("❌ Initial message error: $e");
//     }
//   }

//   static void _setupTokenRefreshListener() {
//     _fcm.onTokenRefresh.listen((newToken) {
//       _fcmToken = newToken;
//       log("🔄 NEW TOKEN RECEIVED: $newToken");
//       _tokenController.add(newToken);
//     });
//   }

//   static Future<void> _tryGetExistingToken() async {
//     try {
//       String? token = await _fcm.getToken();
//       if (token != null && token.isNotEmpty) {
//         _fcmToken = token;
//         log("✅ Existing FCM Token: $token");
//         _tokenController.add(token);
//       } else {
//         log("📱 No existing token found");
//       }
//     } catch (e) {
//       log("⚠️ Token retrieval error: $e");
//     }
//   }

//   static Future<void> _showLocalNotification(RemoteMessage message) async {
//     try {
//       final androidChannel = AndroidNotificationDetails(
//         'dating_channel_id',
//         'Dating Notifications',
//         channelDescription: 'Notifications for dating app activities',
//         importance: Importance.max,
//         priority: Priority.high,
//         playSound: true,
//         enableVibration: true,
//         colorized: true,
//         color: const Color(0xFFFF4D67),
//         largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
//         styleInformation: BigTextStyleInformation(
//           message.notification?.body ?? '',
//           htmlFormatBigText: true,
//           contentTitle: message.notification?.title,
//           htmlFormatContentTitle: true,
//         ),
//         autoCancel: true,
//         ongoing: false,
//         showWhen: true,
//         when: DateTime.now().millisecondsSinceEpoch,
//       );

//       final iosChannel = DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//         sound: 'default',
//         badgeNumber: 1,
//         subtitle: message.notification?.body,
//         threadIdentifier: 'dating-notifications',
//       );

//       final platformDetails = NotificationDetails(
//         android: androidChannel,
//         iOS: iosChannel,
//       );

//       await _notificationsPlugin.show(
//         DateTime.now().millisecondsSinceEpoch ~/ 1000,
//         message.notification?.title ?? 'New Notification',
//         message.notification?.body ?? 'Tap to view details',
//         platformDetails,
//         payload: json.encode(message.data),
//       );
      
//       log("✅ Local notification shown");
//     } catch (e) {
//       log("❌ Local notification error: $e");
//     }
//   }

//   // ========== PUBLIC METHODS ==========

//   static Future<String?> getToken({bool retry = false}) async {
//     if (retry || _fcmToken == null) {
//       await _tryGetExistingToken();
//     }
//     return _fcmToken;
//   }

//   // NEW: Custom notification function
//   static Future<void> showCustomNotification({
//     required int id,
//     required String title,
//     required String body,
//     Map<String, dynamic>? payload,
//     String? channelId,
//     String? channelName,
//     Color? color,
//   }) async {
//     try {
//       final androidDetails = AndroidNotificationDetails(
//         channelId ?? 'custom_channel_id',
//         channelName ?? 'Custom Notifications',
//         channelDescription: 'Custom notifications',
//         importance: Importance.max,
//         priority: Priority.high,
//         playSound: true,
//         enableVibration: true,
//         colorized: true,
//         color: color ?? const Color(0xFF2196F3),
//         autoCancel: true,
//         showWhen: true,
//         when: DateTime.now().millisecondsSinceEpoch,
//       );

//       final iosDetails = DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//         sound: 'default',
//       );

//       final details = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       );

//       await _notificationsPlugin.show(
//         id,
//         title,
//         body,
//         details,
//         payload: payload != null ? json.encode(payload) : null,
//       );
      
//       log("✅ Custom notification shown: $title");
//     } catch (e) {
//       log("❌ Custom notification error: $e");
//     }
//   }

//   // NEW: Text notification function
//   static Future<void> showTextNotification({
//     required String message,
//     required String senderName,
//     String? senderId,
//     String? type = 'message',
//     String? imageUrl,
//   }) async {
//     try {
//       final notificationData = {
//         'type': type,
//         'senderName': senderName,
//         'senderId': senderId ?? '',
//         'body': message,
//         'senderImage': imageUrl,
//         'timestamp': DateTime.now().toIso8601String(),
//       };

//       await showCustomNotification(
//         id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//         title: type == 'message' 
//             ? 'Message from $senderName'
//             : '$senderName sent you a ${type == 'like' ? 'like' : 'match'}',
//         body: message,
//         payload: notificationData,
//         color: _getNotificationColor(type!),
//       );
//     } catch (e) {
//       log("❌ Text notification error: $e");
//     }
//   }

//   static Color _getNotificationColor(String type) {
//     switch (type.toLowerCase()) {
//       case 'like':
//         return const Color(0xFFFF4D67);
//       case 'match':
//         return const Color(0xFF4CAF50);
//       case 'message':
//         return const Color(0xFF2196F3);
//       default:
//         return const Color(0xFF9C27B0);
//     }
//   }

//   static Future<void> showTestNotification() async {
//     try {
//       await showCustomNotification(
//         id: 999,
//         title: 'Test Notification',
//         body: 'This is a test notification from your app',
//         color: Colors.blue,
//       );
//     } catch (e) {
//       log("❌ Test notification error: $e");
//     }
//   }

//   static Future<void> debugDiagnostics() async {
//     log("\n🔍 NOTIFICATION DIAGNOSTICS 🔍");
//     log("Platform: ${defaultTargetPlatform}");
//     log("Current Token: $_fcmToken");
//     log("Initialized: $_isInitialized");
    
//     try {
//       final settings = await _fcm.getNotificationSettings();
//       log("=== Permissions ===");
//       log("Authorization Status: ${settings.authorizationStatus}");
//       log("Alert: ${settings.alert}");
//       log("Badge: ${settings.badge}");
//       log("Sound: ${settings.sound}");
//       // log("Provisional: ${settings.provisional}");
      
//       if (defaultTargetPlatform == TargetPlatform.iOS) {
//         final apnsToken = await _fcm.getAPNSToken();
//         log("APNs Token: $apnsToken");
//       }
      
//       // Check notification channels (Android)
//       if (defaultTargetPlatform == TargetPlatform.android) {
//         final channels = await _notificationsPlugin
//             .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//             ?.getNotificationChannels();
//         log("Available Channels: $channels");
//       }
//     } catch (e) {
//       log("Diagnostics error: $e");
//     }
//     log("🔍 END DIAGNOSTICS 🔍\n");
//   }

//   static void dispose() {
//     _tokenController.close();
//     _notificationController.close();
//   }
// }