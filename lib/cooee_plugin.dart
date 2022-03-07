import 'dart:async';

import 'package:flutter/services.dart';

typedef void CooeeInAppNotificationButtonClickedHandler(
    Map<String, dynamic> mapList);

typedef void CooeeInAppTriggerClosed();

class CooeePlugin {
  CooeeInAppNotificationButtonClickedHandler?
      cooeeInAppNotificationButtonClickedHandler;

  static const MethodChannel _channel = const MethodChannel('cooee_plugin');

  static final CooeePlugin _cooeePlugin = new CooeePlugin._internal();

  ///Default Constructor will point to plugin initialization
  factory CooeePlugin() => _cooeePlugin;

  CooeePlugin._internal() {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  /// Will Listen for @invokeMethod which will triggered by Java SDK
  ///
  /// @param call will hold data arrived from backend
  Future _platformCallHandler(MethodCall call) async {
    var args = call.arguments;
    switch (call.method) {
      case "onInAppButtonClick":
        if (cooeeInAppNotificationButtonClickedHandler == null) {
          break;
        }

        cooeeInAppNotificationButtonClickedHandler!(
            args.cast<String, dynamic>());
        break;
    }
  }

  /// Sends custom events to the server and returns with trigger data(if any)
  ///
  /// @param eventName       Name the event like onDeviceReady
  /// @param eventProperties Properties associated with the event
  static void sendEvent(String eventName,
      [Map<String, dynamic>? eventProperties]) async {
    _channel.invokeMethod("sendEvent",
        {"eventName": eventName, "eventProperties": eventProperties});
  }

  /// Send given user data to the server
  ///
  /// @param userData The common user data like name, email.
  @Deprecated("Use updateUserProfile(Map) instead")
  static void updateUserData(Map<String, dynamic> userData) async {
    updateUserProfile(userData);
  }

  /// Send given user properties to the server
  ///
  /// @param userProperties The additional user properties.
  @Deprecated("Use updateUserProfile(Map) instead")
  static void updateUserProperties(Map<String, dynamic> userProperties) async {
    updateUserProfile(userProperties);
  }

  /// Send given user data to the server
  ///
  /// @param userData The common user data like name, email, etc.
  ///
  /// @since 1.3.0
  static void updateUserProfile(Map<String, dynamic> userData) async {
    _channel.invokeMethod("updateUserProfile", {"updateUserProfile": userData});
  }

  /// Manually update screen name
  ///
  /// @param screenName Screen name given by user
  static void setCurrentScreen(String screenName) async {
    await _channel.invokeMethod("setCurrentScreen", {"screenName": screenName});
  }

  /// Launch DebugInfoActivity activity which holds debug information.
  /// These information is useful to debug problem with the SDK.
  static void showDebugInfo() async {
    await _channel.invokeMethod("showDebugInfo", {});
  }

  /// Provides user ID assigned to the user by Cooee.
  static Future<String?> getUserID() async {
    return await _channel.invokeMethod("getUserID", {});
  }

  /// Define a method to handle inApp notification button clicked
  void setCooeeInAppNotificationAction(
      CooeeInAppNotificationButtonClickedHandler? handler) {
    cooeeInAppNotificationButtonClickedHandler = handler;
  }
}
