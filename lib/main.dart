import 'dart:async';

import 'package:event_creater/firebase_options.dart';
import 'package:event_creater/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:event_creater/pages/login_page.dart';
import 'package:event_creater/pages/registry_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late StreamSubscription<User?> _sub;

  @override
  void initState() {
    super.initState();
    _sub = FirebaseAuth.instance.authStateChanges().listen((event) {
      _navigatorKey.currentState!.pushReplacementNamed(
        event != null ? '/home' : '/login',
      );
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: _navigatorKey,
        debugShowCheckedModeBanner: false,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Home();
            } else {
              return const Login();
            }
          },
        ),
        theme: ThemeData(
          primaryColor: const Color(0xff090979),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: const Color(0xff00d4ff)),
          primarySwatch: Colors.blue,
        ),
        initialRoute:
          FirebaseAuth.instance.currentUser == null ? '/login' : '/home',
        routes: {
          '/login': (context) => const Login(),
          '/registry': (context) => const Registry(),
          '/home': (context) => const Home()
        }
    );
  }
}
