import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
            Messaging.messaging().delegate = self
                 if #available(iOS 10.0, *) {
                     UNUserNotificationCenter.current().delegate = self
                     UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
                         guard success else {
                             return
                         }

                         print("Success in APN Registry")
                     }
                 } else {
                     // Fallback on earlier versions
                     application.registerUserNotificationSettings(UIUserNotificationSettings(types: UIUserNotificationType.sound, categories: nil))
                 }

             if let localNotification = launchOptions?[UIApplication.LaunchOptionsKey.localNotification] as? UILocalNotification {

                 }
                 application.registerForRemoteNotifications()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
                 messaging.token {token, _ in
                     guard let token  = token else{
                         return
                     }
                     print("Token: \(token)")
                 }
             }
}