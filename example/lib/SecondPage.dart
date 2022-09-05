import 'package:cooee_plugin/cooee_plugin.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  @override
  _SecondPage createState() => _SecondPage();
}

class _SecondPage extends State<SecondPage> {
  String name = "";
  String email = "";
  String mobile = "";

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    CooeePlugin.setCurrentScreen("Profile Screen");
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Profile'),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                child: Column(children: [
                  TextField(
                    onChanged: (text) {
                      name = text;
                    },
                    decoration: InputDecoration(
                        label: Text("Name"), hintText: "John Smith"),
                    textInputAction: TextInputAction.done,
                  ),
                  TextField(
                    onChanged: (text) {
                      email = text;
                    },
                    decoration: InputDecoration(
                      label: Text("Email"),
                      hintText: "john.smith@gmail.com",
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    onChanged: (text) {
                      mobile = text;
                    },
                    decoration: InputDecoration(
                      label: Text("Mobile"),
                      hintText: "9876543210",
                    ),
                    textInputAction: TextInputAction.done,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                  ),
                  RaisedButton(
                    onPressed: () {
                      updateProfile(context);
                    },
                    child: Text("Update"),
                  )
                ]),
              ),
            ),
          ),
        ));
  }

  void updateProfile(BuildContext context) {
    if (name.isEmpty) {
      showAlertDialog(context, "Name can not be empty", "Warning");
      return;
    }
    if (email.isEmpty) {
      showAlertDialog(context, "Email can not be empty", "Warning");
      return;
    }
    if (mobile.isEmpty) {
      showAlertDialog(context, "Mobile can not be empty", "Warning");
      return;
    }
    CooeePlugin.updateUserProfile(
        {"name": name, "email": email, mobile: mobile});
    showAlertDialog(
        context,
        "Profile Updated Successfully.\n Press back button to return home.",
        "Success");
  }

  Future showAlertDialog(BuildContext context, String body, String title) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(body),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
