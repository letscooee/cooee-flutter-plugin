import 'dart:async';

import 'package:flutter/services.dart';

typedef void CooeeInAppNotificationButtonClickedHandler(
    Map<String, dynamic> mapList);

class CooeePlugin {
  static CooeeInAppNotificationButtonClickedHandler
      cooeeInAppNotificationButtonClickedHandler;

  static const MethodChannel _channel = const MethodChannel('cooee_plugin');

  static final CooeePlugin _cooeePlugin = new CooeePlugin._internal();

  factory CooeePlugin() => _cooeePlugin;

  CooeePlugin._internal() {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  Future _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "onInAppButtonClick":
        var args = call.arguments;
        cooeeInAppNotificationButtonClickedHandler(
            args.cast<String, dynamic>());
        break;
    }
  }

  /// Sends custom events to the server and returns with trigger data(if any)
  ///
  /// @param eventName       Name the event like onDeviceReady
  /// @param eventProperties Properties associated with the event
  static void sendEvent(
      String eventName, Map<String, String> eventProperties) async {
    await _channel.invokeMethod("sendEvent",
        {"eventName": eventName, "eventProperties": eventProperties});
  }

  /// Send given user data to the server
  ///
  /// @param userData The common user data like name, email.
  static void updateUserData(Map<String, String> userData) async {
    await _channel.invokeMethod("updateUserData", {"userData": userData});
  }

  /// Send given user properties to the server
  ///
  /// @param userProperties The additional user properties.
  static void updateUserProperties(Map<String, String> userProperties) async {
    await _channel.invokeMethod(
        "updateUserProperties", {"userProperties": userProperties});
  }

  /// Manually update screen name
  ///
  /// @param screenName Screen name given by user
  static void setCurrentScreen(String screenName) async {
    await _channel.invokeMethod("setCurrentScreen", {"screenName": screenName});
  }

  /// Define a method to handle inApp notification button clicked
  static void setCooeeInAppNotificationAction(
      CooeeInAppNotificationButtonClickedHandler handler) {
    cooeeInAppNotificationButtonClickedHandler = handler;
  }

  @override
  Map<String, String> onClick() {
    Future _platformCallHandler(MethodCall call) async {
      switch (call.method) {
        case "onInAppButtonClick":
          Map<String, String> args = call.arguments;
          return args;
      }
    }
  }
}
