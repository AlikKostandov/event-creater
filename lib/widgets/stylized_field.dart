import 'package:flutter/material.dart';

class StylizedField extends StatelessWidget {
  final String hintText;
  final bool isObscure;
  TextEditingController controller = TextEditingController();

  StylizedField.withController(
      {super.key, required this.hintText, required this.isObscure, required this.controller});

  StylizedField(
      {super.key, required this.hintText, required this.isObscure});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF9F9797)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.only(left: 20.0),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1.5, color: Colors.black),
            borderRadius: BorderRadius.circular(15.0),
          )),
      style: const TextStyle(fontSize: 20.0, fontFamily: 'Khand'),
      obscureText: isObscure,
    );
  }
}
