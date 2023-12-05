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
        return web;
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
    apiKey: 'AIzaSyCa9E7gXUmD_axvGwrVL8reOy49XIDh9d8',
    appId: '1:633469872201:web:14c028376a5ca01cd03798',
    messagingSenderId: '633469872201',
    projectId: 'profilnium',
    authDomain: 'profilnium.firebaseapp.com',
    storageBucket: 'profilnium.appspot.com',
    measurementId: 'G-60QJNESK9Q',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC8rGqfYZAPnQTzYRVNwn4ao0ONui_ttnY',
    appId: '1:633469872201:android:a0c12e9c9724bb59d03798',
    messagingSenderId: '633469872201',
    projectId: 'profilnium',
    storageBucket: 'profilnium.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCoX9w5heTvy5DWhPx33ux-6LNN7oJdoPg',
    appId: '1:633469872201:ios:ba3a27c7b88d9349d03798',
    messagingSenderId: '633469872201',
    projectId: 'profilnium',
    storageBucket: 'profilnium.appspot.com',
    iosBundleId: 'com.sukmatech.profilnium',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCoX9w5heTvy5DWhPx33ux-6LNN7oJdoPg',
    appId: '1:633469872201:ios:ba3a27c7b88d9349d03798',
    messagingSenderId: '633469872201',
    projectId: 'profilnium',
    storageBucket: 'profilnium.appspot.com',
    iosBundleId: 'com.sukmatech.profilnium',
  );
}
