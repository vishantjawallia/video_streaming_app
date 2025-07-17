import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> showPlatformDialog(BuildContext context, String title, String content) {
  if (Platform.isIOS) {
    return showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(title: Text(title), content: Text(content), actions: [CupertinoDialogAction(child: const Text('OK'), onPressed: () => Navigator.pop(context))]),
    );
  } else {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(title: Text(title), content: Text(content), actions: [TextButton(child: const Text('OK'), onPressed: () => Navigator.pop(context))]),
    );
  }
}
