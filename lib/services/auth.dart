import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future signOut() async {
    await auth.signOut();
  }
  Future deleteUser() async {
    User? user = await auth.currentUser;
    user?.delete();
  }
}