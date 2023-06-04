import 'package:flutter/material.dart';

class EventBox extends StatelessWidget {
  final Color color;
  final String name;
  final String description;

  const EventBox(
      {super.key,
      required this.color,
      required this.name,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      height: 82.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0, color: Colors.white),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 50.0,
            width: 50.0,
            margin: const EdgeInsets.only(left: 15.0),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(width: 0, color: color),
              borderRadius: const BorderRadius.all(Radius.circular(100)),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFF777777),
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(fontSize: 14.0, color: Color(0xFF777777)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
