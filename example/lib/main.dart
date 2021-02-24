import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cooee_plugin/cooee_plugin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

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
        "name": "Ashish flutter",
        "email": "ashish@flutter.com",
        "mobile": "98745632102"
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }

  void initHandlers() {
    CooeePlugin sdk = new CooeePlugin();
    sdk.setCooeeInAppNotificationButtonClickedHandler(inAppTriggered);
  }
}
