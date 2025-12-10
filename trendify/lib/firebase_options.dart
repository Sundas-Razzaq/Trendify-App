import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static const firebaseConfigWeb = {
    "apiKey": "AIzaSyAIZuFijUfD-PXeAgsrleLODU38-_T2G4o",
    "authDomain": "trendify-d21da.firebaseapp.com",
    "projectId": "trendify-d21da",
    "storageBucket": "trendify-d21da.firebasestorage.app",
    "messagingSenderId": "218811410150",
    "appId": "1:218811410150:web:0819602d1f423d086e7d27",
  };

  // Provide a FirebaseOptions instance for the current platform.
  static FirebaseOptions get currentPlatform {
    // Currently only web config is available in this file.
    return FirebaseOptions(
      apiKey: firebaseConfigWeb['apiKey']!,
      authDomain: firebaseConfigWeb['authDomain'],
      projectId: firebaseConfigWeb['projectId']!,
      storageBucket: firebaseConfigWeb['storageBucket']!,
      messagingSenderId: firebaseConfigWeb['messagingSenderId']!,
      appId: firebaseConfigWeb['appId']!,
    );
  }
}
