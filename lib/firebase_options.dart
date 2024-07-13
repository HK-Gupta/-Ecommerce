// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAkDHjAP7Apguo67Jq89Av_SRY1RZbT4Ws',
    appId: '1:1019420542319:web:db54e15578ada91574549a',
    messagingSenderId: '1019420542319',
    projectId: 'happy-food-ecf6b',
    authDomain: 'happy-food-ecf6b.firebaseapp.com',
    databaseURL: 'https://happy-food-ecf6b-default-rtdb.firebaseio.com',
    storageBucket: 'happy-food-ecf6b.appspot.com',
    measurementId: 'G-BBR4Z10WDT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyARtBbwFhRdprxC-PHTauEGS_3xU5E66Kc',
    appId: '1:1019420542319:android:ea75b1f8820c68d474549a',
    messagingSenderId: '1019420542319',
    projectId: 'happy-food-ecf6b',
    databaseURL: 'https://happy-food-ecf6b-default-rtdb.firebaseio.com',
    storageBucket: 'happy-food-ecf6b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCku7B-gc_Cp7_DjE45LOnKTXVRWw2LK60',
    appId: '1:1019420542319:ios:4f7118867c685ca374549a',
    messagingSenderId: '1019420542319',
    projectId: 'happy-food-ecf6b',
    databaseURL: 'https://happy-food-ecf6b-default-rtdb.firebaseio.com',
    storageBucket: 'happy-food-ecf6b.appspot.com',
    androidClientId: '1019420542319-d4p1i58a77ecdkoura9i2ucmmravv7n4.apps.googleusercontent.com',
    iosClientId: '1019420542319-5t9ftradnueb7a2unf16t46u9b08ul0e.apps.googleusercontent.com',
    iosBundleId: 'com.example.shoppingApp',
  );
}
