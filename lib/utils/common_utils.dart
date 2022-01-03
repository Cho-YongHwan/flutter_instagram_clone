import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void FlutterToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      webPosition: 'center',
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      fontSize: 20.0,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT
  );
}