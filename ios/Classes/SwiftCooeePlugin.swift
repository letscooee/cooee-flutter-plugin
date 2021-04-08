import UIKit
import CooeeSDK

public class SwiftCooeePlugin: NSObject, FlutterPlugin {
    var sdkInstance = RegisterUser.shared
    
    static public func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "cooee_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftCooeePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "setup"{
            if let fToken = call.arguments as? String{
                sdkInstance.setup(firebaseToken: fToken)
                result("Cooee is all set!")
            }
        }
        
        if call.method == "getUDID"{
            let UDID = RegisterUser.shared.fetchUDID() ?? ""
            result(UDID)
        }
        
        if call.method == "sendEvent"{
            if let eventParams = call.arguments as? [Any]{
                if let eventName = eventParams[0] as? String, let eventProperties = eventParams[1] as? [String: String] {
                    sdkInstance.sendEvent(withName: eventName, properties: eventProperties)
                    result("Event sent")
                }
            }
        }
        
        if call.method == "updateUserProperties"{
            if let userProperties = call.arguments as? [String: String]{
                sdkInstance.updateProfile(withProperties: userProperties, andData: nil)
                result("User Properties Updated")
            }
        }
        
        if call.method == "updateUserData"{
            if let userData = call.arguments as? [String: String]{
                sdkInstance.updateProfile(withProperties: nil, andData: userData)
                result("User Data Updated")
            }
        }
        
        if call.method == "setCurrentScreen"{
            if let screenName = call.arguments as? String{
                sdkInstance.screenName = screenName
                result("Screen name set")
            }
        }
    }
}
