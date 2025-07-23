import Flutter
import UIKit
import Firebase
import FirebaseCrashlytics
import FirebaseAnalytics

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase'i başlat
    FirebaseApp.configure()
    
    // Crashlytics'i etkinleştir
    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
    
    // Analytics'i etkinleştir
    Analytics.setAnalyticsCollectionEnabled(true)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
