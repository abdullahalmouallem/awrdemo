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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyBpwzg-rxghILfarG2v8VHHVyy4ymZ-p_c',
    appId: '1:861730427573:web:43c9d9d462b48f4fcfa4fc',
    messagingSenderId: '861730427573',
    projectId: 'test-awr',
    authDomain: 'test-awr.firebaseapp.com',
    storageBucket: 'test-awr.appspot.com',
    databaseURL: "https://test-awr-default-rtdb.firebaseio.com/",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBllsGlWaEqq1DGISXy9Ypj-uMEYWCLktY',
    appId: '1:861730427573:android:9f00cc2968647dd8cfa4fc',
    messagingSenderId: '861730427573',
    projectId: 'test-awr',
    storageBucket: 'test-awr.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgbXEaMQZx9RNxdZSJuXjwCMKyl5oTpsA',
    appId: '1:861730427573:ios:28acdf67d6a8d59bcfa4fc',
    messagingSenderId: '861730427573',
    projectId: 'test-awr',
    storageBucket: 'test-awr.appspot.com',
    iosBundleId: 'com.example.awr',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDgbXEaMQZx9RNxdZSJuXjwCMKyl5oTpsA',
    appId: '1:861730427573:ios:28acdf67d6a8d59bcfa4fc',
    messagingSenderId: '861730427573',
    projectId: 'test-awr',
    storageBucket: 'test-awr.appspot.com',
    iosBundleId: 'com.example.awr',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBpwzg-rxghILfarG2v8VHHVyy4ymZ-p_c',
    appId: '1:861730427573:web:55d28cbdfa5344b2cfa4fc',
    messagingSenderId: '861730427573',
    projectId: 'test-awr',
    authDomain: 'test-awr.firebaseapp.com',
    storageBucket: 'test-awr.appspot.com',
  );
}
