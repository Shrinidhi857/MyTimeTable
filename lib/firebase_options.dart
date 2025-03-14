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
    apiKey: 'AIzaSyBJ0MkW9F-apTDxkfRRQJw-JXKc7OXKKmE',
    appId: '1:456213449386:web:e57d37a3b1623f03d59ed3',
    messagingSenderId: '456213449386',
    projectId: 'timetable-59c5e',
    authDomain: 'timetable-59c5e.firebaseapp.com',
    storageBucket: 'timetable-59c5e.firebasestorage.app',
    measurementId: 'G-YQTYHM2DWV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAxzT51bG2Rdpa-eH5oWXrcKz5IwQ236E0',
    appId: '1:456213449386:android:2ff20d405d83458fd59ed3',
    messagingSenderId: '456213449386',
    projectId: 'timetable-59c5e',
    storageBucket: 'timetable-59c5e.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-apg8QjNLLVNvLEVy6TyUyV2V64aSpVc',
    appId: '1:456213449386:ios:28afef62636967f1d59ed3',
    messagingSenderId: '456213449386',
    projectId: 'timetable-59c5e',
    storageBucket: 'timetable-59c5e.firebasestorage.app',
    androidClientId: '456213449386-hr0lk6fk8jmhou8nt5tgjug70k0d24i4.apps.googleusercontent.com',
    iosClientId: '456213449386-3c8anj8iomv9s2dvtne5ld52ahh5igbq.apps.googleusercontent.com',
    iosBundleId: 'com.mytimetable.mytimetable',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC-apg8QjNLLVNvLEVy6TyUyV2V64aSpVc',
    appId: '1:456213449386:ios:28afef62636967f1d59ed3',
    messagingSenderId: '456213449386',
    projectId: 'timetable-59c5e',
    storageBucket: 'timetable-59c5e.firebasestorage.app',
    androidClientId: '456213449386-hr0lk6fk8jmhou8nt5tgjug70k0d24i4.apps.googleusercontent.com',
    iosClientId: '456213449386-3c8anj8iomv9s2dvtne5ld52ahh5igbq.apps.googleusercontent.com',
    iosBundleId: 'com.mytimetable.mytimetable',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBJ0MkW9F-apTDxkfRRQJw-JXKc7OXKKmE',
    appId: '1:456213449386:web:996ebbce46a347d1d59ed3',
    messagingSenderId: '456213449386',
    projectId: 'timetable-59c5e',
    authDomain: 'timetable-59c5e.firebaseapp.com',
    storageBucket: 'timetable-59c5e.firebasestorage.app',
    measurementId: 'G-01G11885K6',
  );

}