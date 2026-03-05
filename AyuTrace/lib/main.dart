import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/di/injection_container.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // NOTE: You need to run `flutterfire configure` to generate firebase_options.dart
  // Then uncomment the line below and import the firebase_options.dart file:
  // import 'firebase_options.dart';
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // For now, initialize Firebase with default options
  await Firebase.initializeApp();

  // Initialize dependency injection
  await initDependencies();

  runApp(const AyuTraceApp());
}
