import 'package:flutter/material.dart';

void MyMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: "DONE",
        onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
      ),
    ),
  );
}
