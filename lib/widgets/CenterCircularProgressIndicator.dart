import 'package:flutter/material.dart';

class CenterCircularProgressIndicator extends StatelessWidget {
  final Color? color;
  final double strokeWidth;

  const CenterCircularProgressIndicator({
    super.key,
    this.color = Colors.amber,
    this.strokeWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color,
        strokeWidth: strokeWidth,
      ),
    );
  }
}