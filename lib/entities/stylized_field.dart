import 'package:flutter/material.dart';

class StylizedField extends StatelessWidget {
  final String hintText;
  final bool isObscure;

  StylizedField({required this.hintText, required this.isObscure});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
      child: TextField(
          decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(color: Color(0xFF9F9797)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.only(left: 20.0),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2.0, color: Colors.black),
                borderRadius: BorderRadius.circular(13.0),
              )),
          style: const TextStyle(fontSize: 20.0, fontFamily: 'Khand'),
          obscureText: isObscure),
    );
  }
}
