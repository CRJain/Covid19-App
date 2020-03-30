import 'package:flutter/material.dart';

class XMargin extends StatelessWidget {
  final double x;
  const XMargin(this.x);
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: x);
  }
}

class YMargin extends StatelessWidget {
  final double y;
  const YMargin(this.y);
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: y);
  }
}

double screenHeight(BuildContext context, {double percent = 1}) =>
    MediaQuery.of(context).size.height * percent;

double screenWidth(BuildContext context, {double percent = 1}) =>
    MediaQuery.of(context).size.width * percent;


class CardColors {
  static const Color blue = Color(0xff356DE4);
  static const Color green = Color(0xff61BD80);
  static const Color red = Color(0xffE54141);
  static const Color cyan = Color(0xff3DB6BA);
  static Color transparentBlack = Colors.black.withOpacity(0.07);
}