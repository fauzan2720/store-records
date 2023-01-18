import 'package:flutter/material.dart';
import 'package:store_records/state_util.dart';
import '/core.dart';

void showConfirmation({
  required void Function() onPressed,
  Color? color,
  String? message,
}) async {
  bool confirm = false;
  await showDialog<void>(
    context: Get.currentContext,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(message ?? 'Are you sure?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "No",
              style: TextStyle(color: Colors.blueGrey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? Colors.red[700],
            ),
            onPressed: () {
              confirm = true;
              Navigator.pop(context);
            },
            child: const Text(
              "Yes",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );

  if (confirm) {
    onPressed();
  }
}
