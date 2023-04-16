import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/screens/auth_screen.dart';
import 'package:firebase_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'firebase_options.dart';

bool shouldUseFirestoreEmulator = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Connected To Firebase /////////////////////////////////////////////////////
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final fcmToken = await FirebaseMessaging.instance.getToken();
  print(fcmToken);

  FirebaseMessaging.onMessage.listen((event) {
    print('msg: ${event}');
  });

  if (shouldUseFirestoreEmulator) {
    FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static Future<void> setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLanguage(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('en');

  changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'Flutter Chat',
        locale: _locale,
        theme: ThemeData(
            primarySwatch: Colors.indigo,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.deepPurple,
              accentColor: Colors.orange,
            ),
            buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.pink, textTheme: ButtonTextTheme.primary)),
        // home: Container(
        //   child: Localizations.override(
        //       context: context,
        //       locale: const Locale('en'),
        //       child: AuthScreen()),
        // ));
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('username: ${snapshot.data!.displayName}');
              return ChatScreen();
            } else {
              return AuthScreen();
            }
          },
        ));
  }
}
