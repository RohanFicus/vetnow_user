import 'package:flutter/material.dart';

class ResponsiveSizes {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double scale(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return size * (width / 375); // base on iPhone X width
  }
}
