import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trendify/firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
