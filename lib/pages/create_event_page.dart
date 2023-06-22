import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/header_widget.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final double _headerHeight = 150;
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        //Header
        Stack(children: <Widget>[
          SizedBox(
            height: _headerHeight,
            child: HeaderWidget(
                _headerHeight), //let's create a common header widget
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 35.0)),
                Container(
                  width: 220.0,
                  child: TextField(
                    controller: _titleController,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                        hintText: 'Event Title',
                        hintStyle: TextStyle(color: Color(0xFF9F9797)),
                        border: InputBorder.none),
                    style: const TextStyle(
                        fontSize: 26.0,
                        fontFamily: 'Lobster',
                        color: Colors.white),
                  ),
                ),
                TextButton(
                    onPressed: () => print('awd'),
                    child: const Text(
                      'Save',
                      style: TextStyle(color: Colors.black, fontSize: 18.0),
                    ))
              ],
            ),
          ),
        ]),
      ],
    ));
  }
}
