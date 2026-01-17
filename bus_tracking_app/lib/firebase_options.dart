import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC_1EGX4FKMDU7e_jvfrG-1-4ZoSd1CVzM',
    appId: '1:481080557436:web:0fd12b215d094a8cc76ef9',
    messagingSenderId: '481080557436',
    projectId: 'bus-tracking-mobile-app-cfaa2',
    authDomain: 'bus-tracking-mobile-app-cfaa2.firebaseapp.com',
    storageBucket: 'bus-tracking-mobile-app-cfaa2.firebasestorage.app',
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
    // This will be set by platform-specific implementations
    throw UnsupportedError('DefaultFirebaseOptions.currentPlatform is not implemented');
  }
}
