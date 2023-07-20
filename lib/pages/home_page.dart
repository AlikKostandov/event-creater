import 'dart:core';
import 'dart:typed_data';

import 'package:event_creater/entity/event_entity.dart';
import 'package:event_creater/entity/simple_user.dart';
import 'package:event_creater/services/event_service.dart';
import 'package:event_creater/services/user_service.dart';
import 'package:event_creater/widgets/event_box.dart';
import 'package:event_creater/widgets/header_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final double _headerHeight = 135;

  bool isLoading = true;
  bool _isCreateButtonVisible = true;
  final ScrollController _scrollController = ScrollController();

  List<EventEntity>? events;
  User? user;
  SimpleUser? simpleUser;
  Uint8List? decodedImage;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    _scrollController.addListener(() {
      if (_scrollController.offset <
              _scrollController.position.maxScrollExtent &&
          _isCreateButtonVisible) {
        setState(() {
          _isCreateButtonVisible = false;
        });
      } else if (_scrollController.offset <=
              _scrollController.position.minScrollExtent &&
          !_isCreateButtonVisible) {
        setState(() {
          _isCreateButtonVisible = true;
        });
      }
    });

    if (user != null) {
      setState(() {
        _fetchUserData();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserData() async {
    simpleUser = await UserService.getUser(user!.email);
    events = await EventService.getUserEvents(simpleUser!.id);
    decodedImage = await UserService.getUserAvatar(simpleUser!.id);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _myKey = new GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _myKey,
        backgroundColor: const Color(0xFFE6E6E6),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Stack(children: <Widget>[
                    SizedBox(
                      height: _headerHeight,
                      child: HeaderWidget(
                          _headerHeight), //let's create a common header widget
                    ),
                    // Header with avatar shape and userInfo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 40.0, bottom: 15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              // Avatar shape
                              Container(
                                  height: 140.0,
                                  width: 140.0,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 10.0,
                                        color: const Color(0xFFE6E6E6),
                                      ),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: CircleAvatar(
                                    backgroundImage: decodedImage != null
                                        ? MemoryImage(decodedImage!)
                                        : const AssetImage(
                                                'assets/img_avatar.png')
                                            as ImageProvider<Object>?,
                                    child: InkWell(
                                      onTap: () async {
                                        if (decodedImage == null) {
                                          await UserService.uploadAvatar(
                                              simpleUser!.id);
                                          Navigator.pushReplacementNamed(
                                              context, '/home');
                                        }
                                      },
                                      child: null,
                                    ),
                                  )),
                              // UserInfo fields
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${simpleUser?.name} ${simpleUser?.surname}",
                                      style: const TextStyle(
                                          fontSize: 24.0,
                                          fontWeight: FontWeight.w800)),
                                  Text(
                                      "${simpleUser?.gender} ${simpleUser?.birthDt != null ? DateFormat('d MMMM yyyy').format(simpleUser!.birthDt!) : ""}",
                                      style: const TextStyle(
                                          fontSize: 14.0, color: Colors.grey)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Icon for open drawer
                        Row(
                          children: [
                            IconButton(
                              onPressed: () =>
                                  _myKey.currentState?.openEndDrawer(),
                              icon: const Icon(Icons.menu),
                              color: Colors.black,
                              iconSize: 40,
                              padding:
                                  const EdgeInsets.only(top: 50.0, right: 20.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
                  // List of events
                  Expanded(
                      child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: events == null ? 0 : events!.length,
                    itemBuilder: (context, index) {
                      final e = events![index];
                      return EventBox(
                        event: e,
                        onDismissed: () {
                          setState(() {
                            events!
                                .removeWhere((element) => element.id == e.id);
                          });
                        },
                      );
                    },
                  )),
                ],
              ),
        // Drawer menu
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
                          Navigator.pushReplacementNamed(context, "/login");
                        });
                        return;
                      },
                      child: Text(
                        'Logout'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20.0, fontFamily: 'Mukta'),
                      ))
                ],
              ),
            ],
          ),
        ),
        // Button for route in create page
        floatingActionButton: Visibility(
          visible: _isCreateButtonVisible,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/add', (route) => false,
                  arguments: simpleUser!.id);
            },
            backgroundColor: CupertinoColors.activeBlue,
            child: const Icon(Icons.add, size: 25.0),
          ),
        ),
        // Bottom navigation bar
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
