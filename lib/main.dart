import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/screens/auth_screen.dart';
import 'package:firebase_app/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'firebase_options.dart';

bool shouldUseFirestoreEmulator = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  if (shouldUseFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Chat',
        theme: ThemeData(
            primarySwatch: Colors.indigo,
            colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.deepPurple,
                accentColor: Colors.orange,
                backgroundColor: Colors.pink),
            scaffoldBackgroundColor: Colors.pink,
            buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.pink, textTheme: ButtonTextTheme.primary)),
        home: AuthScreen());
  }
}
