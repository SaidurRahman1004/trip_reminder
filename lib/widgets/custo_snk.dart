import 'package:flutter/material.dart';

void mySnkmsg(String msg, BuildContext context,
    {Color? backgroundColor, bool isError = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: backgroundColor ??
          (isError ? Colors.redAccent : Colors.black87),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(10),
    ),
  );
}