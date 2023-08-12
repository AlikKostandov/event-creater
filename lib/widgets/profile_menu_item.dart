import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String title;
  String? pathTo;
  final Icon itemIcon;
  Color? color;

  MenuItem(
      {super.key,
      required this.title,
      this.pathTo,
      required this.itemIcon,
      this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (pathTo != null) {
          Navigator.pushReplacementNamed(context, pathTo!);
        } else {
          FirebaseAuth.instance.signOut().then((value) {
            Navigator.pushReplacementNamed(context, "/login");
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 50.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: const BoxDecoration(
            border:
                Border(bottom: BorderSide(color: Colors.black, width: 0.1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                color: color != null
                    ? color!.withOpacity(0.5)
                    : const Color(0xFF6387FA).withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(100)),
              ),
              child: itemIcon,
            ),
            Text(title,
                style: const TextStyle(
                    color: Colors.black,
                    fontFamily: 'Mukta',
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold)),
            Container(
              height: 32.0,
              width: 32.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
