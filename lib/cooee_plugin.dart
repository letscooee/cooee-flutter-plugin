import 'dart:async';

import 'package:flutter/services.dart';

typedef void CooeeInAppNotificationButtonClickedHandler(
    Map<String, String> mapList);

class CooeePlugin {

  CooeeInAppNotificationButtonClickedHandler cooeeInAppNotificationButtonClickedHandler;

  static const MethodChannel _channel = const MethodChannel('cooee_plugin');

  CooeePlugin._internal() {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  Future _platformCallHandler(MethodCall call) async {
    switch(call.method){
      case "onInAppButtonClick":
        Map<String, String> args = call.arguments;
        cooeeInAppNotificationButtonClickedHandler(args);
    }
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void sendEvent(String eventName, Map<String, String> eventProperties) async {
    await _channel.invokeMethod("sendEvent", {"eventName": eventName, "eventProperties": eventProperties});
  }

  static void updateUserData(Map<String, String> userData) async {
    await _channel.invokeMethod("updateUserData", {"userData": userData});
  }

  static void updateUserProperties(Map<String, String> userProperties) async {
    await _channel.invokeMethod("updateUserProperties", {"userProperties": userProperties});
  }

  static void setCurrentScreen(String screenName) async {
    await _channel.invokeMethod("setCurrentScreen", {"screenName": screenName});
  }

  /// Define a method to handle inApp notification button clicked
  void setCooeeInAppNotificationButtonClickedHandler(CooeeInAppNotificationButtonClickedHandler handler) {
    cooeeInAppNotificationButtonClickedHandler = handler;
  }
}
