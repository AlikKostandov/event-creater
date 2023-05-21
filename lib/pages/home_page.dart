import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

Future<String?> signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushNamed(context, "/login");
    });
    return null;
  } on FirebaseAuthException catch (ex) {
    return "${ex.code}: ${ex.message}";
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.red,
        body: Center(
            child: TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut().then((value) {
              Navigator.pushNamed(context, "/login");
            });
            return;
          },
          child: const Text("Logout"),
        )));
  }
}
