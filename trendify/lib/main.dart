import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:trendify/firebase_options.dart';
import 'app.dart';
import 'utils/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Request browser notification permission (no-op on non-web platforms)
  try {
    await NotificationService().requestPermission();
  } catch (_) {}

  runApp(const MyApp());
}
