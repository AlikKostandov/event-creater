import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:event_creater/entity/event_entity.dart';
import 'package:event_creater/entity/simple_user.dart';
import 'package:event_creater/widgets/event_box.dart';
import 'package:event_creater/widgets/header_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
  List<EventEntity>? events;
  User? user;
  SimpleUser? simpleUser;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      getUser(user!.email);
    }
  }

  // Get SimpleUser by email of auth User
  Future<void> getUser(String? email) async {
    final response = await http.get(Uri.parse(
        'http://192.168.1.120:9000/event-creator/users?email=${email!}'));
    if (response.statusCode == 200) {
      String jsonBody = response.body;
      dynamic data = jsonDecode(jsonBody);
      setState(() {
        simpleUser = SimpleUser.fromJson(data);
      });
      if (simpleUser != null) {
        getUserEvents(simpleUser!.id);
      }
    } else {
      print('Ошибка: ${response.statusCode}');
    }
  }

  // Get events list by SimpleUser's id
  Future<void> getUserEvents(int? id) async {
    if (id != null) {
      final response = await http.get(Uri.parse(
          'http://192.168.1.120:9000/event-creator/events?userId=$id'));
      if (response.statusCode == 200) {
        String jsonBody = response.body;
        final parsed = jsonDecode(jsonBody).cast<Map<String, dynamic>>();
        events = parsed
            .map<EventEntity>((json) => EventEntity.fromJson(json))
            .toList();
      } else {
        print('Ошибка: ${response.statusCode}');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> uploadImage(int? id) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);

      final compressedImage = await FlutterImageCompress.compressWithFile(
        imageFile.path,
        quality: 50,
      );

      if (id != null && compressedImage != null) {
        String image = base64Encode(compressedImage);

        final response = await http.put(
            Uri.parse(
                'http://192.168.1.120:9000/event-creator/users/$id/avatar-upload'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8'
            },
            body: image);

        if (response.statusCode == 200) {
          setState(() {
            isLoading = false;
          });
        } else {
          print('Ошибка: ${response.statusCode}');
        }
      }
    }
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
                                    backgroundImage: const AssetImage(
                                        'assets/img_avatar.png'),
                                    child: InkWell(
                                      onTap: () async =>
                                          await uploadImage(simpleUser!.id),
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
                      child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: events == null
                        ? []
                        : events!
                            .map((e) => EventBox(
                                  event: e,
                                  onDismissed: () {
                                    events!.removeWhere(
                                        (element) => element.id == e.id);
                                  },
                                ))
                            .toList(),
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
              Row(
                children: [
                  const Icon(Icons.add),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/add', (route) => false,
                            arguments: simpleUser!.id);
                      },
                      child: Text(
                        'Create event'.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Mukta',
                            letterSpacing: 2.0),
                      ))
                ],
              ),
            ],
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
