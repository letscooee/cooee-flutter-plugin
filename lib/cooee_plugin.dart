import 'dart:async';

import 'package:flutter/services.dart';

class CooeePluginFlutter {

  static const MethodChannel _channel = const MethodChannel('cooee_plugin');

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

  static void setScreenName(String screenName) async {
    await _channel.invokeMethod("setScreenName", {"screenName": screenName});
  }
}
