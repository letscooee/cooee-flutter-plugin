import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cooee_plugin/glassmorphism_effect.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:ui' as ui;

import 'package:shared_preferences/shared_preferences.dart';

typedef void CooeeInAppNotificationButtonClickedHandler(
    Map<String, dynamic> mapList);

typedef void CooeeInAppTriggerClosed();

class CooeePlugin {
  CooeeInAppNotificationButtonClickedHandler
      cooeeInAppNotificationButtonClickedHandler;
  CooeeInAppTriggerClosed cooeeInAppTriggerClosed;
  BuildContext context;

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
    switch (call.method) {
      case "onInAppButtonClick":
        var args = call.arguments;
        cooeeInAppNotificationButtonClickedHandler(
            args.cast<String, dynamic>());
        break;
      case "onInAppTriggered":
        try {
          showCupertinoModalPopup(
              context: context, builder: (context) => GlassmophismEffect());
        } catch (error) {
          print(error.toString());
        }
        break;
      case "onInAppCloseTriggered":
        cooeeInAppTriggerClosed();
        break;
    }
  }

  /// Sends custom events to the server and returns with trigger data(if any)
  ///
  /// @param eventName       Name the event like onDeviceReady
  /// @param eventProperties Properties associated with the event
  static void sendEvent(
      String eventName, Map<String, dynamic> eventProperties) async {
     _channel.invokeMethod("sendEvent",
        {"eventName": eventName, "eventProperties": eventProperties});
  }

  /// Send given user data to the server
  ///
  /// @param userData The common user data like name, email.
  static void updateUserData(Map<String, dynamic> userData) async {
     _channel.invokeMethod("updateUserData", {"userData": userData});
  }

  /// Send given user properties to the server
  ///
  /// @param userProperties The additional user properties.
  static void updateUserProperties(Map<String, dynamic> userProperties) async {
     _channel.invokeMethod(
        "updateUserProperties", {"userProperties": userProperties});
  }

  /// Manually update screen name
  ///
  /// @param screenName Screen name given by user
  static void setCurrentScreen(String screenName) async {
    await _channel.invokeMethod("setCurrentScreen", {"screenName": screenName});
  }

  /// Define a method to handle inApp notification button clicked
  void setCooeeInAppNotificationAction(
      CooeeInAppNotificationButtonClickedHandler handler) {
    cooeeInAppNotificationButtonClickedHandler = handler;
  }

  ///Send Base64 Image to Cooee SDK
  ///
  /// @param base64Encode will be image in base64 format
  Future<void> setBitmap(String base64encode) async {
    await _channel.invokeMethod("setBitmap", {"base64encode": base64encode});
  }

  ///FUnction will take screenshot of current UI using
  ///
  /// @param globalKey will be object of GlobalKey which will passed by User
  Future<void> setController(GlobalKey<State<StatefulWidget>> globalKey) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    RenderRepaintBoundary boundary =
        globalKey.currentContext.findRenderObject();

    ui.Image image = await boundary.toImage(pixelRatio: 1);
    //final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    setBitmap(base64Encode(pngBytes));
    sharedPrefarence(base64Encode(pngBytes));
  }

  ///Save Image in SharedPrefarence
  ///
  /// @param image will be base64 image
  Future<void> sharedPrefarence(String image) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('base64', image);
  }

  ///Load base64 image from SharedPrefarence and pass it to setBitmap
  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    setBitmap(prefs.getString('base64'));
  }

  ///Accept context from user
  ///
  /// @param context BuildContext
  void setContext(BuildContext context) {
    this.context = context;
  }

  void setCooeeInAppTriggerClosed(CooeeInAppTriggerClosed handler) {
    cooeeInAppTriggerClosed = handler;
  }

  void init() async{
    _channel.invokeMethod("init",{});
  }
}
