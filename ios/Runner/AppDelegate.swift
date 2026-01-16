import Flutter
import UIKit
import GoogleMaps // 1. Important: Add this import

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // 2. Add this line with your Google Maps API Key
    GMSServices.provideAPIKey("AIzaSyAGmdSqGPgz_-Qoc669E8U7pHNTAJWGGSU")
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}