import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cooee_plugin.dart';

/// @author Ashish Gaikwad
///
/// Custom widget for Gassmorphism effect
class GlassmorphismEffect extends StatefulWidget {
  int blur;
  String color;

  GlassmorphismEffect(int blur, String color) {
    this.blur = blur;
    this.color = color;
  }

  @override
  _GlassmorphismEffect createState() => _GlassmorphismEffect(blur, color);
}

class _GlassmorphismEffect extends State<GlassmorphismEffect> {
  var cooeePlugin = CooeePlugin();
  int blur;
  String color;
  var dartColor;

  _GlassmorphismEffect(int blur, String color) {
    this.blur = blur;
    this.color = color;
    dartColor = fromHex(color);
  }

  @override
  void initState() {
    super.initState();
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: blur.toDouble(), sigmaY: blur.toDouble()),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: dartColor),
        ),
      ),
    );
  }
}
