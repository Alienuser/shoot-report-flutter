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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUAWubr5qIVqHMQBJkiLRToSzPYdD2QIU',
    appId: '1:629596194534:android:45bf7590911c6066f29d27',
    messagingSenderId: '629596194534',
    projectId: 'shoot-report',
    databaseURL: 'https://shoot-report-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'shoot-report.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0kBYDyLgj8_YfzFQ7fI0oMjkN-EKiGDs',
    appId: '1:629596194534:ios:965e722699e9c590f29d27',
    messagingSenderId: '629596194534',
    projectId: 'shoot-report',
    databaseURL: 'https://shoot-report-default-rtdb.europe-west1.firebasedatabase.app',
    storageBucket: 'shoot-report.appspot.com',
    androidClientId: '629596194534-t992p933mn9813mk9jflp69s7210rrac.apps.googleusercontent.com',
    iosBundleId: 'com.example.shootReportFlutter2',
  );
}
