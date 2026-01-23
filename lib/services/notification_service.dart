// import 'dart:async';
// import 'dart:developer';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class FirebaseNotificationService {
//   static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
  
//   static bool _isInitialized = false;
//   static String? _fcmToken;
//   static Timer? _iosTokenRetryTimer;
  
//   // Stream controllers for handling notification events
//   static final StreamController<Map<String, dynamic>> _notificationStreamController =
//       StreamController<Map<String, dynamic>>.broadcast();
  
//   static Stream<Map<String, dynamic>> get notificationStream =>
//       _notificationStreamController.stream;

//   // ✅ Fixed initialization with iOS token delay handling
//   static Future<String?> init() async {
//     if (_isInitialized) {
//       log("✅ Notifications already initialized");
//       return _fcmToken;
//     }
    
//     try {
//       log("🚀 Initializing Firebase notifications...");
      
//       // 1. Request permissions
//       await _requestPermissions();
      
//       // 2. Initialize local notifications
//       await _initializeLocalNotifications();
      
//       // 3. Set up notification handlers
//       await _setupNotificationHandlers();
      
//       // 4. Get FCM token (with iOS-specific handling)
//       await _getFCMTokenWithSmartRetry();
      
//       // 5. Set up token refresh listener
//       _setupTokenRefreshListener();
      
//       _isInitialized = true;
//       log("✅ Firebase notifications initialized successfully");
      
//       return _fcmToken;
//     } catch (e, stackTrace) {
//       log("❌ Error initializing notifications: $e");
//       log("Stack trace: $stackTrace");
//       return null;
//     }
//   }

//   // ✅ Request notification permissions
//   static Future<void> _requestPermissions() async {
//     try {
//       final settings = await _fcm.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         announcement: false,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: defaultTargetPlatform == TargetPlatform.iOS,
//       );
      
//       log("📱 Notification permission: ${settings.authorizationStatus}");
      
//       // For iOS, set foreground presentation options
//       if (defaultTargetPlatform == TargetPlatform.iOS) {
//         await _fcm.setForegroundNotificationPresentationOptions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );
//         log("📱 iOS foreground presentation options set");
//       }
//     } catch (e) {
//       log("❌ Error requesting permissions: $e");
//     }
//   }

//   // ✅ Initialize local notifications
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
//       );

//       const InitializationSettings settings = InitializationSettings(
//         android: androidSettings,
//         iOS: iosSettings,
//         macOS: iosSettings,
//       );

//       await _notificationsPlugin.initialize(
//         settings,
//         onDidReceiveNotificationResponse: _onNotificationResponse,
//         onDidReceiveBackgroundNotificationResponse: _onNotificationResponse,
//       );
      
//       log("✅ Local notifications initialized");
//     } catch (e) {
//       log("❌ Error initializing local notifications: $e");
//     }
//   }

//   // ✅ Set up notification handlers
//   static Future<void> _setupNotificationHandlers() async {
//     // Foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       log("📱 FOREGROUND NOTIFICATION");
//       log("Message ID: ${message.messageId}");
//       log("Title: ${message.notification?.title}");
//       log("Body: ${message.notification?.body}");
//       log("Data: ${message.data}");
      
//       _showLocalNotification(message);
      
//       // Add to stream for UI updates
//       _notificationStreamController.add({
//         'type': 'foreground',
//         'title': message.notification?.title,
//         'body': message.notification?.body,
//         'data': message.data,
//         'timestamp': DateTime.now(),
//       });
//     });

//     // When app is opened from notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       log("📱 APP OPENED FROM NOTIFICATION");
//       log("Data: ${message.data}");
      
//       _handleNotificationClick(message);
      
//       _notificationStreamController.add({
//         'type': 'opened',
//         'data': message.data,
//         'timestamp': DateTime.now(),
//       });
//     });

//     // Get initial notification when app is opened from terminated state
//     try {
//       RemoteMessage? initialMessage = await _fcm.getInitialMessage();
//       if (initialMessage != null) {
//         log("📱 INITIAL NOTIFICATION (APP TERMINATED)");
//         log("Title: ${initialMessage.notification?.title}");
//         log("Data: ${initialMessage.data}");
        
//         _handleNotificationClick(initialMessage);
        
//         _notificationStreamController.add({
//           'type': 'initial',
//           'data': initialMessage.data,
//           'timestamp': DateTime.now(),
//         });
//       }
//     } catch (e) {
//       log("❌ Error getting initial message: $e");
//     }
//   }

//   // ✅ Smart FCM token retrieval with iOS delay handling
//   static Future<void> _getFCMTokenWithSmartRetry() async {
//     if (defaultTargetPlatform == TargetPlatform.iOS) {
//       await _getIOSFCMToken();
//     } else {
//       await _getAndroidFCMToken();
//     }
//   }

//   // ✅ Android token retrieval
//   static Future<void> _getAndroidFCMToken() async {
//     try {
//       String? token = await _fcm.getToken();
//       if (token != null && token.isNotEmpty) {
//         _fcmToken = token;
//         log("✅ Android FCM Token: $token");
//         await _sendTokenToServer(token);
//       } else {
//         log("⚠️ Android token is null/empty");
//       }
//     } catch (e) {
//       log("❌ Android token error: $e");
//     }
//   }

//   // ✅ iOS token retrieval with retry logic
// // ✅ iOS token retrieval with retry logic - FIXED VERSION
// static Future<void> _getIOSFCMToken() async {
//   log("📱 Starting iOS FCM token retrieval...");
  
//   // Cancel any existing retry timer
//   _iosTokenRetryTimer?.cancel();
  
//   // Try immediate retrieval
//   try {
//     String? token = await _fcm.getToken();
//     if (token != null && token.isNotEmpty) {
//       _fcmToken = token;
//       log("✅ iOS FCM Token (immediate): $token");
//       await _sendTokenToServer(token);
//       return;
//     } else {
//       log("⏳ iOS token is null (normal for first launch)");
//     }
//   } catch (e) {
//     log("⚠️ iOS immediate token error (normal): $e");
//   }
  
//   log("⏳ iOS APNs token not ready yet, waiting for refresh event...");
  
//   // Don't retry calling getToken() - just wait for onTokenRefresh event
//   // The onTokenRefresh stream will fire when APNs token is ready
//   _setupIOSTokenWait();
// }

// // ✅ Set up waiting for iOS token via refresh event
// static void _setupIOSTokenWait() {
//   // Set a timeout to check if token arrives
//   Timer(const Duration(seconds: 60), () {
//     if (_fcmToken == null) {
//       log("⏱️ iOS token wait timeout after 60 seconds");
//       log("💡 Tips:");
//       log("   - Check device internet connection");
//       log("   - Make sure Push Notifications are enabled in Settings");
//       log("   - Restart the app");
//       log("   - The token will come on next app launch");
//     }
//   });
// }
//   // ✅ Check APNs token status
//   static Future<void> _checkIOSAPNSTokenStatus() async {
//     try {
//       String? apnsToken = await _fcm.getAPNSToken();
//       if (apnsToken != null) {
//         log("📱 iOS APNs Token: $apnsToken");
//       } else {
//         log("⚠️ iOS APNs token still null");
//         log("💡 Possible causes:");
//         log("   - First app launch on device");
//         log("   - No internet connection");
//         log("   - Push notifications not enabled in device settings");
//         log("   - App needs to be restarted");
//       }
//     } catch (e) {
//       log("❌ APNs token check error: $e");
//     }
//   }

//   // ✅ Send token to server
//   static Future<void> _sendTokenToServer(String token) async {
//     try {
//       log("📤 Sending token to server: $token");
//       // TODO: Implement your API call
//       // await apiService.updateFCMToken(token);
//     } catch (e) {
//       log("❌ Error sending token to server: $e");
//     }
//   }

//   // ✅ Set up token refresh listener
//   static void _setupTokenRefreshListener() {
//     _fcm.onTokenRefresh.listen((newToken) {
//       _fcmToken = newToken;
//       log("🔄 TOKEN REFRESHED: $newToken");
      
//       _sendTokenToServer(newToken);
      
//       // For iOS, also check APNs
//       if (defaultTargetPlatform == TargetPlatform.iOS) {
//         _checkIOSAPNSTokenStatus();
//       }
//     });
//   }

//   // ✅ Show local notification
//   static Future<void> _showLocalNotification(RemoteMessage message) async {
//     try {
//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//         'dating_channel',
//         'Dating Notifications',
//         channelDescription: 'Notifications for dating app',
//         importance: Importance.max,
//         priority: Priority.high,
//         showWhen: true,
//         playSound: true,
//         enableVibration: true,
//         ticker: 'New notification',
//       );

//       const DarwinNotificationDetails iosDetails =
//           DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//         sound: 'default',
//         badgeNumber: 1,
//         threadIdentifier: 'dating-notifications',
//       );

//       const NotificationDetails platformDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//         macOS: iosDetails,
//       );

//       await _notificationsPlugin.show(
//         DateTime.now().millisecondsSinceEpoch ~/ 1000,
//         message.notification?.title ?? 'New Match!',
//         message.notification?.body ?? 'You have a new notification',
//         platformDetails,
//         payload: message.data.isNotEmpty 
//             ? _encodeNotificationData(message.data)
//             : message.notification?.body,
//       );
      
//       log("✅ Local notification shown");
//     } catch (e) {
//       log("❌ Error showing notification: $e");
//     }
//   }

//   // ✅ Encode notification data for payload
//   static String _encodeNotificationData(Map<String, dynamic> data) {
//     try {
//       return data.toString();
//     } catch (e) {
//       return 'error_encoding_data';
//     }
//   }

//   // ✅ Handle notification click
//   static void _handleNotificationClick(RemoteMessage message) {
//     try {
//       final data = message.data;
//       log("🎯 Notification clicked with data: $data");
      
//       // Navigation logic
//       final notificationType = data['type']?.toString().toLowerCase() ?? '';
      
//       if (notificationType.contains('match')) {
//         // Navigate to matches
//         log("➡️ Navigate to matches screen");
//       } else if (notificationType.contains('message') || notificationType.contains('chat')) {
//         // Navigate to chat
//         log("➡️ Navigate to chat screen");
//       } else if (notificationType.contains('like')) {
//         // Navigate to likes
//         log("➡️ Navigate to likes screen");
//       }
      
//       _notificationStreamController.add({
//         'type': 'click_handled',
//         'data': data,
//         'timestamp': DateTime.now(),
//       });
//     } catch (e) {
//       log("❌ Error handling click: $e");
//     }
//   }

//   // ✅ Handle local notification response
//   static void _onNotificationResponse(NotificationResponse response) {
//     log("🎯 Local notification clicked: ${response.payload}");
    
//     try {
//       if (response.payload != null) {
//         _notificationStreamController.add({
//           'type': 'local_click',
//           'payload': response.payload,
//           'timestamp': DateTime.now(),
//         });
//       }
//     } catch (e) {
//       log("❌ Error processing local response: $e");
//     }
//   }

//   // ========== PUBLIC METHODS ==========

//   // ✅ Get current FCM token
//   static Future<String?> getToken({bool forceRefresh = false}) async {
//     if (forceRefresh || _fcmToken == null) {
//       try {
//         String? token = await _fcm.getToken();
//         if (token != null) {
//           _fcmToken = token;
//           log("🔄 Token refreshed: $token");
//         }
//       } catch (e) {
//         log("❌ Error getting token: $e");
//       }
//     }
//     return _fcmToken;
//   }

//   // ✅ Subscribe to topic
//   static Future<void> subscribeToTopic(String topic) async {
//     try {
//       await _fcm.subscribeToTopic(topic);
//       log("✅ Subscribed to topic: $topic");
//     } catch (e) {
//       log("❌ Error subscribing to $topic: $e");
//     }
//   }

//   // ✅ Unsubscribe from topic
//   static Future<void> unsubscribeFromTopic(String topic) async {
//     try {
//       await _fcm.unsubscribeFromTopic(topic);
//       log("✅ Unsubscribed from topic: $topic");
//     } catch (e) {
//       log("❌ Error unsubscribing from $topic: $e");
//     }
//   }

//   // ✅ Delete token
//   static Future<void> deleteToken() async {
//     try {
//       await _fcm.deleteToken();
//       _fcmToken = null;
//       log("✅ Token deleted");
//     } catch (e) {
//       log("❌ Error deleting token: $e");
//     }
//   }

//   // ✅ Show test notification
//   static Future<void> showTestNotification() async {
//     try {
//       const AndroidNotificationDetails androidDetails =
//           AndroidNotificationDetails(
//         'dating_channel',
//         'Dating Notifications',
//         channelDescription: 'Test notification',
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker',
//         playSound: true,
//         enableVibration: true,
//       );

//       const DarwinNotificationDetails iosDetails =
//           DarwinNotificationDetails(
//         presentAlert: true,
//         presentBadge: true,
//         presentSound: true,
//         sound: 'default',
//       );

//       const NotificationDetails platformDetails = NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//         macOS: iosDetails,
//       );

//       await _notificationsPlugin.show(
//         999,
//         'Test Notification',
//         'This is a test notification from the dating app',
//         platformDetails,
//         payload: 'test_payload_${DateTime.now().millisecondsSinceEpoch}',
//       );
      
//       log("✅ Test notification shown");
//     } catch (e) {
//       log("❌ Error showing test notification: $e");
//     }
//   }

//   // ✅ Get APNs token (iOS only)
//   static Future<String?> getAPNSToken() async {
//     if (defaultTargetPlatform == TargetPlatform.iOS) {
//       try {
//         return await _fcm.getAPNSToken();
//       } catch (e) {
//         log("❌ Error getting APNs token: $e");
//         return null;
//       }
//     }
//     return null;
//   }

//   // ✅ Check notification permissions
//   static Future<bool> checkPermissions() async {
//     try {
//       final settings = await _fcm.getNotificationSettings();
//       return settings.authorizationStatus == AuthorizationStatus.authorized;
//     } catch (e) {
//       log("❌ Error checking permissions: $e");
//       return false;
//     }
//   }

//   // ✅ Open notification settings
//   static Future<void> openNotificationSettings() async {
//     try {
//       await _fcm.requestPermission();
//     } catch (e) {
//       log("❌ Error opening settings: $e");
//     }
//   }

//   // ✅ Clean up resources
//   static void dispose() {
//     _iosTokenRetryTimer?.cancel();
//     _iosTokenRetryTimer = null;
//     _notificationStreamController.close();
//     log("🧹 Notification service disposed");
//   }

//   // ✅ Debug method: Print all settings
//   static Future<void> debugPrintSettings() async {
//     try {
//       final settings = await _fcm.getNotificationSettings();
//       log("🔍 Notification Settings:");
//       log("  Authorization: ${settings.authorizationStatus}");
//       log("  Alert: ${settings.alert}");
//       log("  Badge: ${settings.badge}");
//       log("  Sound: ${settings.sound}");
      
//       if (defaultTargetPlatform == TargetPlatform.iOS) {
//         final apnsToken = await _fcm.getAPNSToken();
//         log("  APNs Token: $apnsToken");
//       }
      
//       log("  FCM Token: $_fcmToken");
//     } catch (e) {
//       log("❌ Debug print error: $e");
//     }
//   }
// }


import 'dart:async';
import 'dart:developer';
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
      
      // 4. Listen for token refresh (iOS token will come here)
      _setupTokenRefreshListener();
      
      // 5. Try to get existing token (may fail on iOS first launch)
      await _tryGetExistingToken();
      
      _isInitialized = true;
      log("✅ Firebase notifications initialized");
      
    } catch (e) {
      log("❌ Notification init error: $e");
    }
  }

  static Future<void> _requestPermissions() async {
    try {
      final settings = await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        
        provisional: true, // Allows silent permission on iOS
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
        requestAlertPermission: false, // Already requested
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
          log("🎯 Notification clicked: ${response.payload}");
          _notificationController.add({
            'type': 'local_click',
            'payload': response.payload,
            'timestamp': DateTime.now(),
          });
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
      log("📱 Foreground notification: ${message.notification?.title}");
      
      _showLocalNotification(message);
      
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
      
      _handleNotificationData(message.data);
    });

    // Initial notification when app launched from terminated state
    try {
      RemoteMessage? initialMessage = await _fcm.getInitialMessage();
      if (initialMessage != null) {
        log("📱 Initial notification from terminated state");
        _handleNotificationData(initialMessage.data);
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
      _sendTokenToServer(newToken);
    });
  }

  static Future<void> _tryGetExistingToken() async {
    try {
      String? token = await _fcm.getToken();
      if (token != null && token.isNotEmpty) {
        _fcmToken = token;
        log("✅ Existing FCM Token: $token");
        _tokenController.add(token);
        _sendTokenToServer(token);
      } else {
        if (defaultTargetPlatform == TargetPlatform.iOS) {
          log("📱 iOS: No existing token (normal for first launch)");
          log("💡 The token will arrive via onTokenRefresh stream");
          log("💡 Try restarting the app or waiting a few minutes");
        } else {
          log("📱 Android: No existing token");
        }
      }
    } catch (e) {
      log("⚠️ Token retrieval error: $e");
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        log("📱 This is normal for iOS first launch");
      }
    }
  }

  static Future<void> _sendTokenToServer(String token) async {
    try {
      log("📤 Sending token to server: $token");
      // TODO: Implement your API call
      // await apiService.updateFCMToken(token);
    } catch (e) {
      log("❌ Server error: $e");
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
        payload: message.data.toString(),
      );
    } catch (e) {
      log("❌ Notification show error: $e");
    }
  }

  static void _handleNotificationData(Map<String, dynamic> data) {
    log("🎯 Handling notification data: $data");
    // Implement your navigation logic here
  }

  // ========== PUBLIC METHODS ==========

  static Future<String?> getToken({bool retry = false}) async {
    if (retry || _fcmToken == null) {
      try {
        String? token = await _fcm.getToken();
        if (token != null) {
          _fcmToken = token;
          log("🔄 Retrieved token: $token");
        }
      } catch (e) {
        log("❌ Get token error: $e");
      }
    }
    return _fcmToken;
  }

  static Future<String?> forceRefreshToken() async {
    try {
      // For iOS, we need to wait for the token
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        log("📱 iOS: Requesting token refresh...");
        // iOS token refresh happens automatically
        // Just wait a bit and try to get it
        await Future.delayed(const Duration(seconds: 2));
      }
      
      String? token = await _fcm.getToken();
      if (token != null) {
        _fcmToken = token;
        log("🔄 Force refreshed token: $token");
        _tokenController.add(token);
      }
      return token;
    } catch (e) {
      log("❌ Force refresh error: $e");
      return null;
    }
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




class NotificationDebugScreen extends StatelessWidget {
  const NotificationDebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Debug')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Current Token
            StreamBuilder<String>(
              stream: FirebaseNotificationService.tokenStream,
              builder: (context, snapshot) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('FCM Token', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        if (snapshot.hasData)
                          SelectableText(
                            snapshot.data!,
                            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                          )
                        else
                          const Text('No token yet', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Debug Buttons
            Column(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final token = await FirebaseNotificationService.forceRefreshToken();
                    if (token != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Token: ${token.substring(0, 30)}...')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No token available')),
                      );
                    }
                  },
                  child: const Text('Force Refresh Token'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: FirebaseNotificationService.showTestNotification,
                  child: const Text('Show Test Notification'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: FirebaseNotificationService.debugDiagnostics,
                  child: const Text('Run Diagnostics'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationLogScreen(),
                      ),
                    );
                  },
                  child: const Text('View Notification Log'),
                ),
              ],
            ),

            const SizedBox(height: 30),
            const Divider(),
            const SizedBox(height: 20),

            // Status Info
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('iOS Token Status', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('• First launch: Token may take 30-60 seconds'),
                    Text('• Restart app: Token usually appears on second launch'),
                    Text('• Check Settings → Notifications → Your App'),
                    Text('• Make sure internet connection is stable'),
                    SizedBox(height: 10),
                    Text('Once token appears, you can send test notifications from Firebase Console.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Notification Log Screen
class NotificationLogScreen extends StatelessWidget {
  const NotificationLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Log')),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: FirebaseNotificationService.notificationStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text('No notifications received'));
          }
          
          final data = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text('Type: ${data['type']}'),
              Text('Title: ${data['title'] ?? 'N/A'}'),
              Text('Body: ${data['body'] ?? 'N/A'}'),
              Text('Time: ${data['timestamp']}'),
              const SizedBox(height: 16),
              const Text('Data:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(data['data']?.toString() ?? '{}'),
            ],
          );
        },
      ),
    );
  }
}