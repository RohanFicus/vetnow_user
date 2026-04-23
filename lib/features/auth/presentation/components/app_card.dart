import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double elevation;
  final ShapeBorder? shape;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    this.elevation = 2,
    this.shape,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: elevation,
      shape:
          shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: margin,
      child: Padding(padding: padding, child: child),
    );
  }
}
