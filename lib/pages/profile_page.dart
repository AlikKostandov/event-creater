import 'dart:typed_data';

import 'package:event_creater/services/user_service.dart';
import 'package:event_creater/widgets/profile_menu_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../entity/simple_user.dart';
import '../widgets/header_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  final double _headerHeight = 135;
  bool isLoading = true;
  User? authUser;
  SimpleUser? simpleUser;
  Uint8List? decodedImage;

  @override
  void initState() {
    super.initState();
    authUser = FirebaseAuth.instance.currentUser;
    if (authUser != null) {
      setState(() {
        _fetchUserData();
      });
    }
  }

  Future<void> _fetchUserData() async {
    simpleUser = await UserService.getUser(authUser!.email);
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
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: <Widget>[
                                // Avatar shape
                                Container(
                                    height: 140.0,
                                    width: 140.0,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 10.0,
                                          color: const Color(0xFFE6E6E6),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: CircleAvatar(
                                      backgroundImage: decodedImage != null
                                          ? MemoryImage(decodedImage!)
                                          : const AssetImage(
                                                  'assets/img_avatar.png')
                                              as ImageProvider<Object>?,
                                      child: InkWell(
                                        onTap: () {
                                          if (decodedImage == null) {
                                            UserService.uploadAvatar(
                                                simpleUser!.id);
                                            Navigator.pushReplacementNamed(
                                                context, '/profile');
                                          }
                                        },
                                        child: null,
                                      ),
                                    )),
                                // UserInfo fields
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        "${simpleUser?.name} ${simpleUser?.surname}",
                                        style: const TextStyle(
                                            fontSize: 24.0,
                                            fontWeight: FontWeight.w800)),
                                    Text("${simpleUser?.email}",
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 25.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: const Color(0xFFFF6E27)
                                        .withOpacity(0.7),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      print("edit");
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 1, horizontal: 50.0),
                                      child: const Text(
                                        "Edit Profile",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Mukta',
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 2.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      MenuItem(
                          title: 'Settings',
                          pathTo: 'pathTo',
                          itemIcon: const Icon(
                            Icons.settings,
                            size: 40.0,
                          )),
                      MenuItem(
                          title: 'Archive',
                          pathTo: 'pathTo',
                          itemIcon: const Icon(
                            Icons.archive,
                            size: 40.0,
                          )),
                      MenuItem(
                          title: 'Support',
                          pathTo: 'pathTo',
                          itemIcon: const Icon(
                            Icons.contact_support,
                            size: 40.0,
                          )),
                      MenuItem(
                        title: 'Logout',
                        pathTo: null,
                        itemIcon: const Icon(
                          Icons.logout,
                          size: 35.0,
                        ),
                        color: Colors.red,
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 30.0, horizontal: 20.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 35.0,
                      ),
                    ),
                  )
                ]),
              ],
            ),
    );
  }
}
