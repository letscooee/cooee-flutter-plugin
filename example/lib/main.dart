import 'package:cooee_plugin_example/glass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cooee_plugin/cooee_plugin.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  CooeePlugin sdk;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initHandlers(context);
  }

  void inAppTriggered(Map<String, dynamic> map) {
    this.setState(() {
      print("Data " + map.toString());
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      //CooeePlugin.setCurrentScreen("CartPage");
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
    return MaterialApp(
        home: HomePage(),
     /* ),*/
    );
  }

  void initHandlers(BuildContext context) {
    sdk = new CooeePlugin();
    sdk.setCooeeInAppNotificationAction(inAppTriggered);
    sdk.setContext(context);
  }

  void onclick(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>GlassmophismEffect()));
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,

        child: Center(
          child:
          Column(
              children:[ Image(
                image: new AssetImage('assets/homepage.png'),
                width: 500,
                height: 500,
              ),
                RaisedButton(
                  onPressed: (){
                    onclick(context);
                  },
                ),
              ]
          ),
        ),
      ),
    );
  }

  void onclick(BuildContext context) {
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>GlassmophismEffect()));
    showCupertinoModalPopup(context: context, builder: (context) =>GlassmophismEffect());
  }
}


