import UIKit
import CooeeSDK

public class SwiftCooeePlugin: NSObject, FlutterPlugin {
    var sdkInstance = CooeeSDK.getInstance()
    
    static public func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "cooee_plugin", binaryMessenger: registrar.messenger())
        let instance = SwiftCooeePlugin()
        AppController.configure()
        var sdk = CooeeSDK.getInstance()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        channel.setMethodCallHandler({
              (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

            //instance.handle(call, result:result)

                      if call.method == "getUDID"{
                          let UDID = sdk.getUserID() ?? ""
                          result(UDID)
                      }

                      if call.method == "sendEvent"{
                          guard let eventParams = call.arguments as? [String: Any] else{
                            return
                          }

                          guard let eventName = eventParams["eventName"] as? String else{
                            return
                          }

                          guard let eventProperties = eventParams["eventProperties"] as? [String:Any] else{
                            return
                          }

                          do{
                            try sdk.sendEvent(eventName: eventName,eventProperties: eventProperties);
                            result("Event sent")
                          }catch{}
                      }

                      if call.method == "updateUserProperties"{
                        guard let userProperties = call.arguments as? [String: Any] else{
                            return
                        }

                        sdk.updateUserProperties(userProperties: userProperties);
                      }

                      if call.method == "updateUserData"{
                          guard let userData = call.arguments as? [String: Any] else{
                            return
                          }

                          sdk.updateUserData(userData: userData)
                          result("User Data Updated")
                      }

                      if call.method == "setCurrentScreen"{
                          guard let arguments = call.arguments as? [String: Any] else{
                            return
                          }

                          guard let screenName = arguments["screenName"] as? String else{
                            return
                          }

                          sdk.setCurrentScreen(screenName: screenName)
                          result("Screen name set")
                      }
           })
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
   

        if call.method == "getUDID"{
            let UDID = sdkInstance.getUserID() ?? ""
            result(UDID)
        }

        if call.method == "sendEvent"{
            guard let eventParams = call.arguments as? [String: Any] else{
                return
            }

            guard let eventName = eventParams["eventName"] as? String else{
                return
            }

            guard let eventProperties = eventParams["eventProperties"] as? [String:Any] else{
                return
            }

            do{
                try self.sdkInstance.sendEvent(eventName: eventName,eventProperties: eventProperties);
                result("Event sent")
            }catch{}
        }

        if call.method == "updateUserProperties"{
            guard let userProperties = call.arguments as? [String: Any] else{
                return
            }

            self.sdkInstance.updateUserProperties(userProperties: userProperties);
        }

        if call.method == "updateUserData"{
            guard let userData = call.arguments as? [String: Any] else{
                return
            }

            self.sdkInstance.updateUserData(userData: userData)
            result("User Data Updated")
        }

        if call.method == "setCurrentScreen"{
            guard let arguments = call.arguments as? [String: Any] else{
                return
            }

            guard let screenName = arguments["screenName"] as? String else{
                return
            }

            self.sdkInstance.setCurrentScreen(screenName: screenName)
            result("Screen name set")
        }
    }
}
