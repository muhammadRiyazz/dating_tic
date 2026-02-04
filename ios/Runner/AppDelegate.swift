import UIKit
import Flutter
import GoogleMaps
import Firebase
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {`
    
    // ✅ Google Maps API Key
    GMSServices.provideAPIKey("AIzaSyAGmdSqGPgz_-Qoc669E8U7pHNTAJWGGSU")
    
    // ✅ Firebase init
    FirebaseApp.configure()
    
    // ✅ Set up Firebase Messaging delegate
    Messaging.messaging().delegate = self
    
    // ✅ Set up notifications
    setupNotifications(application)
    
    // ✅ Flutter plugins
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // MARK: - Notification Setup
  private func setupNotifications(_ application: UIApplication) {
    // Request notification permissions
    let center = UNUserNotificationCenter.current()
    center.delegate = self
    
    let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    center.requestAuthorization(options: options) { granted, error in
      if let error = error {
        print("❌ Notification permission error: \(error.localizedDescription)")
        return
      }
      
      if granted {
        print("✅ Notification permissions granted")
        DispatchQueue.main.async {
          application.registerForRemoteNotifications()
        }
      } else {
        print("⚠️ Notification permissions denied")
      }
    }
  }
  
  // MARK: - APNs Registration
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    // Pass device token to Firebase Messaging
    Messaging.messaging().apnsToken = deviceToken
    
    // Convert token to string for debugging
    let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    print("📱 APNs Device Token: \(tokenString)")
    
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
  
  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("❌ Failed to register for remote notifications: \(error.localizedDescription)")
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }
  
  // MARK: - Handle Background Notifications
  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    print("📱 Background notification received: \(userInfo)")
    completionHandler(.newData)
  }
  
  // MARK: - Handle Foreground Notifications
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    let userInfo = notification.request.content.userInfo
    print("📱 Foreground notification received: \(userInfo)")
    
    // Show notification even when app is in foreground
    if #available(iOS 14.0, *) {
      completionHandler([[.banner, .sound, .badge]])
    } else {
      completionHandler([[.alert, .sound, .badge]])
    }
  }
  
  // MARK: - Handle Notification Tap
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    print("📱 Notification tapped: \(userInfo)")
    
    // You can send this to Flutter if needed
    NotificationCenter.default.post(
      name: NSNotification.Name("NotificationTapped"),
      object: nil,
      userInfo: userInfo
    )
    
    completionHandler()
  }
}

// MARK: - Firebase Messaging Delegate
extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("🔥 Firebase FCM Token: \(String(describing: fcmToken))")
    
    // Send token to Flutter if needed
    if let token = fcmToken {
      let dataDict: [String: String] = ["token": token]
      NotificationCenter.default.post(
        name: NSNotification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
    }
  }
}
