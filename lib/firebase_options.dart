// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
    apiKey: 'AIzaSyBkKZRTlEaGS2Us2_BNVCRLqaHT3llim58',
    appId: '1:425066435852:web:9dcb9125be0d3bf5656529',
    messagingSenderId: '425066435852',
    projectId: 'reddit-clone-f7641',
    authDomain: 'reddit-clone-f7641.firebaseapp.com',
    storageBucket: 'reddit-clone-f7641.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBoSoWQr9IPZqEIOscKcdiKQf2qgkGZWqw',
    appId: '1:425066435852:android:a4c5587372874e7e656529',
    messagingSenderId: '425066435852',
    projectId: 'reddit-clone-f7641',
    storageBucket: 'reddit-clone-f7641.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAIM28r8nc-47v3dzbtknJH0-sIsY2vJYI',
    appId: '1:425066435852:ios:ea4d19398bb55db0656529',
    messagingSenderId: '425066435852',
    projectId: 'reddit-clone-f7641',
    storageBucket: 'reddit-clone-f7641.appspot.com',
    iosClientId: '425066435852-1snid6q243p1fkfnuuc80nchq9d4u7fl.apps.googleusercontent.com',
    iosBundleId: 'com.example.redditClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAIM28r8nc-47v3dzbtknJH0-sIsY2vJYI',
    appId: '1:425066435852:ios:ea4d19398bb55db0656529',
    messagingSenderId: '425066435852',
    projectId: 'reddit-clone-f7641',
    storageBucket: 'reddit-clone-f7641.appspot.com',
    iosClientId: '425066435852-1snid6q243p1fkfnuuc80nchq9d4u7fl.apps.googleusercontent.com',
    iosBundleId: 'com.example.redditClone',
  );
}