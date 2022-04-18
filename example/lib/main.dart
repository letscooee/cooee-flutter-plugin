import 'dart:async';

import 'package:cooee_plugin/cooee_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CooeePlugin? sdk;

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
    try {
      CooeePlugin.setCurrentScreen("CartPage");
      var props = {
        "item": {
          "id": "FOO-B076H19JPJ",
          "name": "Adidas Men's Agora 1.0 Multisport Shoe",
          "category": {"id": "15234", "name": "Shoes"}
        },
        "items": [
          {
            "id": "FOO-B076H19JPJ",
            "name": "Adidas Men's Agora 1.0 Multisport Shoe",
            "category": {"id": "15234", "name": "Shoes"}
          },
          {
            "id": "FOO-B076H19JPJ",
            "name": "Adidas Men's Agora 1.0 Multisport Shoe",
            "category": {"id": "15234", "name": "Shoes"}
          }
        ],
        "stringData": "kansldkf",
        "intData": 241234,
        "floatData": 23.2345,
        "booData": true
      };
      CooeePlugin.sendEvent("View Item", props);
      CooeePlugin.sendEvent("Add To Cart");
    } on Exception {
      print(Exception);
    }

    try {
      CooeePlugin.updateUserProfile({
        "name": "Abhishek flutter",
        "email": "abhishek@flutter.com",
        "mobile": 4545454545,
        "foo": "bar",
        "cuisine": "MH"
      });

      CooeePlugin.getUserID().then((cooeeUserID) {
        if (cooeeUserID == null) return;
        setState(() {
          print("User Id: " + cooeeUserID);
        });
      });
    } catch (e) {
      print(e);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }

  void initHandlers(BuildContext context) {
    sdk = new CooeePlugin();
    sdk!.setCooeeInAppNotificationAction(inAppTriggered);
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
          child: Column(children: [
            Image(
              image: new AssetImage('assets/homepage.png'),
              width: 500,
              height: 500,
            ),
            RaisedButton(
              onPressed: () {
                onclick(context);
              },
              child: Text("First page Button"),
            ),
          ]),
        ),
      ),
    );
  }

  void onclick(BuildContext context) {
    CooeePlugin.showDebugInfo();
  }
}

class SecondPage extends StatelessWidget {
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
          child: Column(children: [
            Image(
              image: new AssetImage('assets/homepage.png'),
              width: 600,
              height: 600,
            ),
          ]),
        ),
      ),
    );
  }
}
