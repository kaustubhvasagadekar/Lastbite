// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyD2qdbhtYpqVLDmHkXiutiPGHAj9KhibDg',
    appId: '1:684360527269:web:295a497f09e9374dbf0c4c',
    messagingSenderId: '684360527269',
    projectId: 'last-bite-52e1a',
    authDomain: 'last-bite-52e1a.firebaseapp.com',
    storageBucket: 'last-bite-52e1a.firebasestorage.app',
    measurementId: 'G-XD3Y5LJZK0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxZdtJckhXQzTNIVdrYL3Scr4q-wXhFuw',
    appId: '1:684360527269:android:7467f38fe50d1c5cbf0c4c',
    messagingSenderId: '684360527269',
    projectId: 'last-bite-52e1a',
    storageBucket: 'last-bite-52e1a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCQLPozrP9fKmAq9j_czK-UBbZcwvvBSyk',
    appId: '1:684360527269:ios:f51af9a1766382bebf0c4c',
    messagingSenderId: '684360527269',
    projectId: 'last-bite-52e1a',
    storageBucket: 'last-bite-52e1a.firebasestorage.app',
    iosBundleId: 'com.example.lastBite',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCQLPozrP9fKmAq9j_czK-UBbZcwvvBSyk',
    appId: '1:684360527269:ios:f51af9a1766382bebf0c4c',
    messagingSenderId: '684360527269',
    projectId: 'last-bite-52e1a',
    storageBucket: 'last-bite-52e1a.firebasestorage.app',
    iosBundleId: 'com.example.lastBite',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD2qdbhtYpqVLDmHkXiutiPGHAj9KhibDg',
    appId: '1:684360527269:web:10521ea934105e18bf0c4c',
    messagingSenderId: '684360527269',
    projectId: 'last-bite-52e1a',
    authDomain: 'last-bite-52e1a.firebaseapp.com',
    storageBucket: 'last-bite-52e1a.firebasestorage.app',
    measurementId: 'G-1E78XRBLBS',
  );
}
