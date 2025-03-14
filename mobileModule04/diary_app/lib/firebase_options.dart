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
    apiKey: 'AIzaSyCYpgajpL5uitwf1bM6Lqv7jCmUVFobYMg',
    appId: '1:696347209276:web:1e08003a9c921e071e5d39',
    messagingSenderId: '696347209276',
    projectId: 'diary-app-e9fe7',
    authDomain: 'diary-app-e9fe7.firebaseapp.com',
    storageBucket: 'diary-app-e9fe7.firebasestorage.app',
    measurementId: 'G-2KDPL0RXZV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDNvDcfa5vD2UDou45jW2kOUZ_pks0zRmc',
    appId: '1:696347209276:android:11fc4d0d62ceeb341e5d39',
    messagingSenderId: '696347209276',
    projectId: 'diary-app-e9fe7',
    storageBucket: 'diary-app-e9fe7.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCN1xiXn50NrEqr7HZupqVzyf-DMvswQuM',
    appId: '1:696347209276:ios:16f5528dba061b541e5d39',
    messagingSenderId: '696347209276',
    projectId: 'diary-app-e9fe7',
    storageBucket: 'diary-app-e9fe7.firebasestorage.app',
    iosBundleId: 'com.example.diaryApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCN1xiXn50NrEqr7HZupqVzyf-DMvswQuM',
    appId: '1:696347209276:ios:16f5528dba061b541e5d39',
    messagingSenderId: '696347209276',
    projectId: 'diary-app-e9fe7',
    storageBucket: 'diary-app-e9fe7.firebasestorage.app',
    iosBundleId: 'com.example.diaryApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCYpgajpL5uitwf1bM6Lqv7jCmUVFobYMg',
    appId: '1:696347209276:web:f3bd5a22052c51ad1e5d39',
    messagingSenderId: '696347209276',
    projectId: 'diary-app-e9fe7',
    authDomain: 'diary-app-e9fe7.firebaseapp.com',
    storageBucket: 'diary-app-e9fe7.firebasestorage.app',
    measurementId: 'G-2BP8ZZQR09',
  );
}
