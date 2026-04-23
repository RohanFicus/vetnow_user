import 'package:flutter/material.dart';

Future<T?> showAppDialog<T>({
  required BuildContext context,
  String? title,
  Widget? content,
  List<Widget>? actions,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (ctx) {
      return AlertDialog(
        title: title == null ? null : Text(title),
        content: content,
        actions:
            actions ??
            [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Close'),
              ),
            ],
      );
    },
  );
}
