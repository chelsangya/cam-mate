import 'package:flutter/material.dart';

showMySnackBar({required String message, BuildContext? context, Color? color}) {
  ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color ?? Colors.green,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
