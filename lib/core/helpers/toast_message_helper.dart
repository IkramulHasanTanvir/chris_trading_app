import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessageHelper {
  ToastMessageHelper._();

  static void show(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.grey.shade700,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }
}