import UIKit
import CooeeSDK

public class SwiftCooeePlugin: NSObject, FlutterPlugin {
    var sdkInstance = Cooee.shared
    
    static public func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "cooee_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftCooeePlugin()
         var sdk = Cooee.shared
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        channel.setMethodCallHandler({
              (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
              // Note: this method is invoked on the UI thread.
              // Handle battery messages.
              
              if call.method == "setup"{
                          if let fToken = call.arguments as? String{
                             // sdkInstance.setup(firebaseToken: fToken)
                              result("Cooee is all set!")
                          }
                      }

                      if call.method == "getUDID"{
                          let UDID = Cooee.shared.fetchUDID() ?? ""
                          result(UDID)
                      }

                      if call.method == "sendEvent"{
                          if let eventParams = call.arguments as? [String: Any]{
                              if let eventName = eventParams["eventName"] as? String, let eventProperties = eventParams["eventProperties"] as? [String: Any]{
                                sdk.sendEvent(withName: eventName, properties: eventProperties)
                                  result("Event sent")
                              }
                          }
                      }

                      if call.method == "updateUserProperties"{
                      print("updateUserProperties")
                          if let userProperties = call.arguments as? [String: Any]{
                            sdk.updateProfile(withProperties: userProperties, andData: nil)
                              result("User Properties Updated")
                          }
                      }

                      if call.method == "updateUserData"{
                      print("updateUserData")
                          if let userData = call.arguments as? [String: Any]{
                            sdk.updateProfile(withProperties: nil, andData: userData)
                              result("User Data Updated")
                          }
                      }

                      if call.method == "setCurrentScreen"{
                      print("setCurrentScreen")
                          if let screenName = call.arguments as? String{
                            sdk.screenName = screenName
                              result("Screen name set")
                          }
                      }
            })
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
   
        if call.method == "setup"{
            if let fToken = call.arguments as? String{
               // sdkInstance.setup(firebaseToken: fToken)
                result("Cooee is all set!")
            }
        }
        
        if call.method == "getUDID"{
            let UDID = Cooee.shared.fetchUDID() ?? ""
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
