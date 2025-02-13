import 'dart:ui';

import 'package:flutter/material.dart';

class AppWidget{

  static TextStyle boldTextFieldStyle() {
      return TextStyle(
          color: Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.bold
      );
  }
  static TextStyle lightTextFieldStyle() {
    return TextStyle(
        color: Colors.black54,
        fontSize: 18,
        fontWeight: FontWeight.w500
    );
  }
  static TextStyle semiBoldTextFieldStyle() {
    return TextStyle(
        color: Colors.black,
        fontSize: 21,
        fontWeight: FontWeight.bold
    );
  }
}