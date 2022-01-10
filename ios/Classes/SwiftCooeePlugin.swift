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

    public func onCTAResponse(payload: [String: Any]) {
        SwiftCooeePlugin.channel?.invokeMethod("onInAppButtonClick", arguments: payload)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        SwiftCooeePlugin.processMethod(call, result)
    }

    public static func processMethod(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        if call.method == "getUserID" {
            let UDID = sdkInstance.getUserID() ?? ""
            result(UDID)
        }

        if call.method == "sendEvent" {
            guard let eventParams = call.arguments as? [String: Any] else {
                return
            }

            guard let eventName = eventParams["eventName"] as? String else {
                return
            }

            guard let eventProperties = eventParams["eventProperties"] as? [String: Any] else {
                return
            }

            do {
                try sdkInstance.sendEvent(eventName: eventName, eventProperties: eventProperties)
                result("Event sent")
            } catch {
                result(FlutterError(code: "Invalid Event", message: error.localizedDescription, details: error))
            }
        }

        if call.method == "updateUserProperties" {
            guard let userProperties = call.arguments as? [String: Any] else {
                return
            }

            sdkInstance.updateUserProperties(userProperties: userProperties)
        }

        if call.method == "updateUserData" {
            guard let userData = call.arguments as? [String: Any] else {
                return
            }

            sdkInstance.updateUserData(userData: userData)
            result("User Data Updated")
        }

        if call.method == "setCurrentScreen" {
            guard let arguments = call.arguments as? [String: Any] else {
                return
            }

            guard let screenName = arguments["screenName"] as? String else {
                return
            }

            sdkInstance.setCurrentScreen(screenName: screenName)
            result("Screen name set")
        }
    }

    // MARK: Internal

    static var channel: FlutterMethodChannel?

    static var sdkInstance = CooeeSDK.getInstance()
}
