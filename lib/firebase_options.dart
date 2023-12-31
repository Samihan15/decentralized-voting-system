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
    apiKey: 'AIzaSyB9SVZf3sbQNvoHSWMCwmh_8hOX4IwMxnY',
    appId: '1:370717107975:web:36919ed2a61024011307a2',
    messagingSenderId: '370717107975',
    projectId: 'voting-dapp-da765',
    authDomain: 'voting-dapp-da765.firebaseapp.com',
    storageBucket: 'voting-dapp-da765.appspot.com',
    measurementId: 'G-2K9DSLN225',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAkGz6ftZsH0CiRzBZcLX9vy09kxDwwSl4',
    appId: '1:370717107975:android:b2d79b0276c2e1f41307a2',
    messagingSenderId: '370717107975',
    projectId: 'voting-dapp-da765',
    storageBucket: 'voting-dapp-da765.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDrxZnRXKdOH8GeEV42FtOlrUGVCLumIw',
    appId: '1:370717107975:ios:c93b9a7fb2e4c9451307a2',
    messagingSenderId: '370717107975',
    projectId: 'voting-dapp-da765',
    storageBucket: 'voting-dapp-da765.appspot.com',
    iosClientId: '370717107975-d5enbl2fonagb6fpjao22o4jj7m40uns.apps.googleusercontent.com',
    iosBundleId: 'com.example.votingDapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDDrxZnRXKdOH8GeEV42FtOlrUGVCLumIw',
    appId: '1:370717107975:ios:f2418b4e543cbff41307a2',
    messagingSenderId: '370717107975',
    projectId: 'voting-dapp-da765',
    storageBucket: 'voting-dapp-da765.appspot.com',
    iosClientId: '370717107975-mc5b6llg7qi3shsp029rga4rau1s2tl8.apps.googleusercontent.com',
    iosBundleId: 'com.example.votingDapp.RunnerTests',
  );
}
