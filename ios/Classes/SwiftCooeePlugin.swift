import CooeeSDK
import UIKit

public class SwiftCooeePlugin: NSObject, FlutterPlugin, CooeeCTADelegate {
    // MARK: Public

    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: "cooee_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftCooeePlugin()
        AppController.configure()
        sdkInstance = CooeeSDK.getInstance()
        registrar.addMethodCallDelegate(instance, channel: channel!)

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
    }

    public func onCTAResponse(payload: [String: Any]) {
        SwiftCooeePlugin.channel?.invokeMethod("onInAppButtonClick", arguments: payload)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        SwiftCooeePlugin.processMethod(call, result)
    }

    // MARK: Internal

    static var channel: FlutterMethodChannel?

    static var sdkInstance = CooeeSDK.getInstance()
}
