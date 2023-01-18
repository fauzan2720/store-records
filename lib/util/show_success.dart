import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:store_records/state_util.dart';
import '/core.dart';

void showSuccess({String? message}) {
  Alert(
    context: Get.currentContext,
    type: AlertType.success,
    title: message ?? "Success",
    style: const AlertStyle(backgroundColor: Colors.white),
    buttons: [
      DialogButton(
        color: Colors.blueGrey,
        child: const Text(
          "Oke",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () => Get.back(),
      )
    ],
  ).show();
  return;
}
