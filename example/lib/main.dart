import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cooee_plugin/cooee_plugin.dart';
import 'package:cooee_plugin/cooee_parent.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  Uint8List _imageFile;
  GlobalKey screenshotController = GlobalKey();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initHandlers();
  }

  void inAppTriggered(Map<String, dynamic> map) {
    this.setState(() {
      print("*************** Data " + map.toString());
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      CooeePlugin.setCurrentScreen("CartPage");
      await CooeePlugin.sendEvent("Add To Cart", new Map<String, String>());
    } on Exception {
      print(Exception);
    }

    try {
      await CooeePlugin.updateUserProperties(
          {"foo": "bar", "Purchased Once": "true"});
    } catch (e) {
      print(e);
    }

    try {
      await CooeePlugin.updateUserData({
        "name": "Abhishek flutter",
        "email": "abhishek@flutter.com",
        "mobile": "4545454545"
      });
    } catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CooeeParent(
      key: screenshotController,
      child: MaterialApp(

        home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Container(
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Image(
                image: new AssetImage('assets/homepage.png'),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
      ),
    );
  }

  CooeePlugin sdk;

  void initHandlers() {
    sdk = new CooeePlugin();
    sdk.setCooeeInAppNotificationAction(inAppTriggered);
    sdk.seController(screenshotController);
    //sdk.setGlobalKey(previewContainer);
  }

  void takeScreenShot() async {
    await Future.delayed(const Duration(milliseconds: 20));
    RenderRepaintBoundary boundary =
        screenshotController.currentContext.findRenderObject();

    ui.Image image = await boundary.toImage(pixelRatio: 1);
    //final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    sdk.setBitmap(base64Encode(pngBytes));
  }
}
