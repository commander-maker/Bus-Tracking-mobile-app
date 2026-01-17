import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC_1EGX4FKMDU7e_jvfrG-1-4ZoSd1CVzM',
    appId: '1:481080557436:web:0fd12b215d094a8cc76ef9',
    messagingSenderId: '481080557436',
    projectId: 'bus-tracking-mobile-app-cfaa2',
    authDomain: 'bus-tracking-mobile-app-cfaa2.firebaseapp.com',
    storageBucket: 'https://bus-tracking-mobile-app-cfaa2-default-rtdb.firebaseio.com/',
    measurementId: 'G-R986QN0LXN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_1EGX4FKMDU7e_jvfrG-1-4ZoSd1CVzM',
    appId: '1:481080557436:android:0fd12b215d094a8cc76ef9',
    messagingSenderId: '481080557436',
    projectId: 'bus-tracking-mobile-app-cfaa2',
    storageBucket: 'bus-tracking-mobile-app-cfaa2.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC_1EGX4FKMDU7e_jvfrG-1-4ZoSd1CVzM',
    appId: '1:481080557436:ios:0fd12b215d094a8cc76ef9',
    messagingSenderId: '481080557436',
    projectId: 'bus-tracking-mobile-app-cfaa2',
    storageBucket: 'bus-tracking-mobile-app-cfaa2.firebasestorage.app',
    iosBundleId: 'com.example.bustrackingapp',
  );

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
}
