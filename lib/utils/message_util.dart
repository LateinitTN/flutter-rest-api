import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageUtils{
  void logMessage(String msg){
    log(msg);
  }

  void logJson(String tag, dynamic data){
    JsonEncoder encoder = const JsonEncoder.withIndent('  ');
    var json = encoder.convert(data);
    logMessage("$tag: $json");
  }

  void toastMessageSuccess(String msg){
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      fontSize: 16.0,
      textColor: Colors.white
    );
  }

  void toastMessageError(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.deepOrange,
        fontSize: 16.0,
        textColor: Colors.white
    );
  }
}