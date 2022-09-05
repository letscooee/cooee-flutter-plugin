import CooeeSDK
import Flutter
import UIKit

public class SwiftCooeePlugin: NSObject, FlutterPlugin, CooeeCTADelegate, FlutterApplicationLifeCycleDelegate {
    // MARK: Public

    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "cooee_plugin", binaryMessenger: registrar.messenger())
        configure()
        let instance = SwiftCooeePlugin()
        sdkInstance = CooeeSDK.getInstance()
        sdkInstance.setOnCTADelegate(instance.self)
        registrar.addMethodCallDelegate(instance, channel: channel!)
        registrar.addApplicationDelegate(instance)
        channel?.setMethodCallHandler {
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

            SwiftCooeePlugin.processMethod(call, result)
        }
    }

    public static func processMethod(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if call.method == "getUserID" {
            let UDID = sdkInstance.getUserID() ?? ""
            result(UDID)
        }

        if call.method == "sendEvent" {
            guard let eventParams = call.arguments as? [String: Any] else {
                result(FlutterError(code: "Invalid data", message: "Invalid event data", details: nil))
                return
            }

            guard let eventName = eventParams["eventName"] as? String else {
                result(FlutterError(code: "Empty event name", message: "Event name can not be empty", details: nil))
                return
            }

            let eventProperties = eventParams["eventProperties"] as? [String: Any]

            do {
                try sdkInstance.sendEvent(eventName: eventName, eventProperties: eventProperties)
                result("Event sent")
            } catch {
                result(FlutterError(code: "Invalid event", message: error.localizedDescription, details: error))
            }
        }

        if call.method == "updateUserProfile" {
            guard let callData = call.arguments as? [String: Any] else {
                result(FlutterError(code: "Invalid data", message: "Invalid user profile data", details: nil))
                return
            }

            guard let userProfile = callData["updateUserProfile"] as? [String: Any] else {
                result(FlutterError(code: "Invalid data", message: "Profile data can not be null", details: nil))
                return
            }

            do {
                try sdkInstance.updateUserProfile(userProfile)
                result("User profile updated")
            } catch {
                result(FlutterError(code: "Invalid data", message: error.localizedDescription, details: error))
            }
        }

        if call.method == "setCurrentScreen" {
            guard let arguments = call.arguments as? [String: Any] else {
                result(FlutterError(code: "Invalid data", message: "Invalid screen data", details: nil))
                return
            }

            guard let screenName = arguments["screenName"] as? String else {
                result(FlutterError(code: "Invalid data", message: "Screen name can not be null", details: nil))
                return
            }

            sdkInstance.setCurrentScreen(screenName: screenName)
            result("Screen name set")
        }

        if call.method == "showDebugInfo" {
            sdkInstance.showDebugInfo()
            result("Displaying Debug Info")
        }
    }

    /**
     Sets wrapper information to Native SDK and then start Native SDK implementation
     */
    @objc
    public static func configure() {
        NewSessionExecutor.updateWrapperInformation(wrapperType: .FLUTTER, versionNumber: Constants.VERSION_NAME, versionCode: Constants.VERSION_CODE)
        AppController.configure()
    }

    /**
     Triggered by iOS Lifecycle once app went to foreground
     - parameters:
     - application - Instance of the application
     */
    public func applicationWillEnterForeground(_ application: UIApplication) {
        SwiftCooeePlugin.isAfterForegroundEvent = true
    }

    /**
     Triggered by iOS Lifecycle once app become active.
     Helps only in case of App Launch (Flutter blocks Foreground event when app has fresh launch where Native do not.)
     - parameters:
     - application - Instance of the application
     */
    public func applicationDidBecomeActive(_ application: UIApplication) {
        // Stop relaunching foreground event if this function getting call after foreground event.
        if SwiftCooeePlugin.isAfterForegroundEvent {
            return
        }

        // Add observer to UIViewController So that once flutter UI is loaded we can perform organic launch
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            rootViewController.view.layer.addObserver(self, forKeyPath: "sublayers", options: NSKeyValueObservingOptions.new, context: nil)
        }
    }

    /**
     Observer called as soon as there is change in ViewControllers sub layer (i.e) Flutter UI is  loaded in the ViewController.
     */
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if SwiftCooeePlugin.isAfterForegroundEvent {
            return
        }

        triggerAppForeground()
    }

    public func onCTAResponse(payload: [String: Any]) {
        SwiftCooeePlugin.channel?.invokeMethod("onInAppButtonClick", arguments: payload)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        SwiftCooeePlugin.processMethod(call, result)
    }

    // MARK: Internal

    static var isAfterForegroundEvent = false
    static var channel: FlutterMethodChannel?

    static var sdkInstance = CooeeSDK.getInstance()

    /**
     Trigger App foreground event once app fully launced.
     */
    @objc func triggerAppForeground() {
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}
