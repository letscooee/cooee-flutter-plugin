import CooeeSDK
import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in
                // self.registerCategory()
            }
        )

        UIApplication.shared.registerForRemoteNotifications()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("**** \(deviceToken.reduce("") {$0 + String(format: "%02X", $1)}) for \(Bundle.main.bundleIdentifier)")
        
        CooeeSDK.getInstance().setDeviceToken(token: deviceToken)
    }

    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // print("foreground \(notification.request.content.userInfo)")

        completionHandler(CooeeSDK.getInstance().presentNotification(notification))
    }

    override func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // print("click")

        CooeeSDK.getInstance().notificationAction(response)
        completionHandler()
    }
}
