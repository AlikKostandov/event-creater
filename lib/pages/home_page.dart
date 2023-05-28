import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:event_creater/widgets/header_widget.dart';

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
  final double _headerHeight = 150;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE6E6E6),
        body: Stack(children: <Widget>[
          SizedBox(
            height: _headerHeight,
            child: HeaderWidget(
                _headerHeight), //let's create a common header widget
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 50.0),
                child: Container(
                    height: 140.0,
                    width: 140.0,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 8.0,
                          color: const Color(0xFFE6E6E6),
                        ),
                        borderRadius: BorderRadius.circular(100)),
                    child: const CircleAvatar(
                      backgroundImage: AssetImage('assets/img_avatar.png'),
                    )),
              ),
              Row(
                children: [
                  // IconButton(
                  //   onPressed: () async {},
                  //   icon: const Icon(Icons.menu),
                  //   color: Colors.black,
                  //   iconSize: 40,
                  //   padding: const EdgeInsets.only(top: 50.0),
                  // ),
                  IconButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pushNamed(context, "/login");
                      });
                      return;
                    },
                    icon: const Icon(Icons.logout),
                    color: Colors.black,
                    iconSize: 40,
                    padding: const EdgeInsets.only(top: 50.0, right: 20.0),
                  ),
                ],
              ),
            ],
          ),
        ]));
  }
}
