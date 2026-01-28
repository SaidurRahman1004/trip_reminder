import 'package:flutter/material.dart';
import 'customText.dart';

class CustomRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final double? iconSize;

  const CustomRow({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: iconSize),
        const SizedBox(width: 8),
        Txt(txt: label, fntSize: 16, fontWeight: FontWeight.bold),
      ],
    );
  }
}