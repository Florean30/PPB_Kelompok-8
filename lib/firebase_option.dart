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
    apiKey: "AIzaSyA2Py-VQKJXerk-uL3KfH0gFbv3sSQQhPs",
    authDomain: "lunmobile-479d5.firebaseapp.com",
    databaseURL: "https://lunmobile-479d5-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "lunmobile-479d5",
    storageBucket: "lunmobile-479d5.appspot.com",
    messagingSenderId: "706275359955",
    appId: "1:706275359955:web:871455f9daa1a34186e826",
    measurementId: "G-1S5Z993B8D"
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyA2Py-VQKJXerk-uL3KfH0gFbv3sSQQhPs",
    authDomain: "lunmobile-479d5.firebaseapp.com",
    databaseURL: "https://lunmobile-479d5-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "lunmobile-479d5",
    storageBucket: "lunmobile-479d5.appspot.com",
    messagingSenderId: "706275359955",
    appId: "1:706275359955:web:871455f9daa1a34186e826",
    measurementId: "G-1S5Z993B8D"
  );
}