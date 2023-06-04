import 'package:event_creater/widgets/event_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:event_creater/widgets/header_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

List<EventBox> events = [
  const EventBox(
      color: Colors.grey,
      name: 'John’s Friday Party',
      description: 'John Thompson - 27/06/2021'),
  const EventBox(
      color: Colors.grey,
      name: 'John’s Friday Party',
      description: 'John Thompson - 27/06/2021'),
  const EventBox(
      color: Colors.grey,
      name: 'John’s Friday Party',
      description: 'John Thompson - 27/06/2021'),
  const EventBox(
      color: Colors.grey,
      name: 'John’s Friday Party',
      description: 'John Thompson - 27/06/2021'),
  const EventBox(
      color: Colors.grey,
      name: 'John’s Friday Party',
      description: 'John Thompson - 27/06/2021'),
  const EventBox(
      color: Colors.grey,
      name: 'John’s Friday Party',
      description: 'John Thompson - 27/06/2021'),
  const EventBox(
      color: Colors.grey,
      name: 'John’s Friday Party',
      description: 'John Thompson - 27/06/2021')
];

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
    final GlobalKey<ScaffoldState> _myKey = new GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _myKey,
        backgroundColor: const Color(0xFFE6E6E6),
        body: Column(
          children: [
            Stack(children: <Widget>[
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
                              width: 10.0,
                              color: const Color(0xFFE6E6E6),
                            ),
                            borderRadius: BorderRadius.circular(100)),
                        child: const CircleAvatar(
                          backgroundImage: AssetImage('assets/img_avatar.png'),
                        )),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _myKey.currentState?.openEndDrawer(),
                        icon: const Icon(Icons.menu),
                        color: Colors.black,
                        iconSize: 40,
                        padding: const EdgeInsets.only(top: 50.0, right: 20.0),
                      ),
                    ],
                  ),
                ],
              ),
            ]),
            Expanded(
                child: ListView(
              children: events,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
            )),
          ],
        ),
        endDrawer: Drawer(
          width: 250.0,
          child: ListView(
            padding: const EdgeInsets.only(left: 50.0, top: 30.0),
            children: [
              Row(
                children: [
                  const Icon(Icons.person),
                  TextButton(
                      onPressed: () {
                        print('Profile');
                      },
                      child: Text(
                        'Profile'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Mukta',
                            letterSpacing: 2.0),
                      ))
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.question_mark),
                  TextButton(
                      onPressed: () {
                        print('About us');
                      },
                      child: Text(
                        'About'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Mukta',
                            letterSpacing: 2.0),
                      ))
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.settings),
                  TextButton(
                      onPressed: () {
                        print('Settings');
                      },
                      child: Text(
                        'Settings'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Mukta',
                            letterSpacing: 2.0),
                      ))
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.archive),
                  TextButton(
                      onPressed: () {
                        print('Archive');
                      },
                      child: Text(
                        'Archive'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Mukta',
                            letterSpacing: 2.0),
                      ))
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.login_outlined),
                  TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          Navigator.pushNamed(context, "/login");
                        });
                        return;
                      },
                      child: Text(
                        'Logout'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20.0, fontFamily: 'Mukta'),
                      ))
                ],
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme:
              const IconThemeData(color: Colors.blueAccent, size: 40.0),
          unselectedIconTheme:
              const IconThemeData(color: Colors.grey, size: 30.0),
          backgroundColor: const Color(0xFFE6E6E6),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_alt),
              label: 'Communities',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events_sharp),
              label: 'Achievement',
            ),
          ],
        ));
  }
}
