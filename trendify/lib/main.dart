import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trendify/firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use the web config map provided in `firebase_options.dart` to construct
  // a `FirebaseOptions` instance. Non-null assertions are used for required
  // fields to satisfy the constructor's requirements.
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: DefaultFirebaseOptions.firebaseConfigWeb['apiKey']!,
      authDomain: DefaultFirebaseOptions.firebaseConfigWeb['authDomain'],
      projectId: DefaultFirebaseOptions.firebaseConfigWeb['projectId']!,
      storageBucket: DefaultFirebaseOptions.firebaseConfigWeb['storageBucket']!,
      messagingSenderId:
          DefaultFirebaseOptions.firebaseConfigWeb['messagingSenderId']!,
      appId: DefaultFirebaseOptions.firebaseConfigWeb['appId']!,
    ),
  );

  runApp(const MyApp());
}
