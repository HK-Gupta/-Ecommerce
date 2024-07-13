
import 'package:flutter/material.dart';

void scaffoldMessage(BuildContext context,  String message) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            message,
            style: TextStyle(
              fontSize: 18,
            ),
          )
      )
  );
}
