import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cooee_plugin.dart';

/// @author Ashish Gaikwad
///
/// Custom widget for Gassmorphism effect
class GlassmophismEffect extends StatefulWidget {
  @override
  _GlassmorphismEffect createState() => _GlassmorphismEffect();
}

class _GlassmorphismEffect extends State<GlassmophismEffect> {
  var cooeePlugin = CooeePlugin();

  @override
  void initState() {
    super.initState();

    cooeePlugin.setCooeeInAppTriggerClosed(() {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration:
              BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
        ),
      ),
    );
  }
}
