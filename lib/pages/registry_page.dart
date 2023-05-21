import 'package:event_creater/widgets/stylized_field.dart';
import 'package:flutter/material.dart';

import 'package:event_creater/widgets/header_widget.dart';

import '../auth.dart';

class Registry extends StatefulWidget {
  const Registry({super.key});

  @override
  _RegistryState createState() => _RegistryState();
}
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

List<StylizedField> fields = [
  StylizedField(hintText: "Name", isObscure: false),
  StylizedField(hintText: "Surname", isObscure: false),
  StylizedField.withController(hintText: "Email", isObscure: false, controller: _emailController),
  StylizedField.withController(hintText: "Password", isObscure: true, controller: _passwordController),
  StylizedField(hintText: "Repeat a Password", isObscure: true),
];

class _RegistryState extends State<Registry> {
  final double _headerHeight = 350;
  String? gender;
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: _headerHeight,
              child: HeaderWidget(
                  _headerHeight), //let's create a common header widget
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: Text('Registry',
                        style: TextStyle(
                          fontFamily: 'Khand',
                          fontSize: 80.0,
                        )),
                  ),
                  Column(
                    children: fields
                        .map((field) => Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10.0, left: 30.0, right: 30.0),
                              child: field,
                            ))
                        .toList()
                        .sublist(0, 3),
                  ),
                  Column(
                    children: <Widget>[
                      RadioListTile(
                        activeColor: Colors.black,
                        contentPadding: const EdgeInsets.only(left: 25.0),
                        title: const Text("Male",
                            style:
                                TextStyle(fontFamily: 'Khand', fontSize: 24.0)),
                        value: "male",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                          });
                        },
                      ),
                      RadioListTile(
                        activeColor: Colors.black,
                        contentPadding: const EdgeInsets.only(left: 25.0),
                        title: const Text("Female",
                            style: TextStyle(
                              fontFamily: 'Khand',
                              fontSize: 24.0,
                            )),
                        value: "female",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                          });
                        },
                      ),
                    ],
                  ),
                  Column(
                    children: fields
                        .map((field) => Container(
                              margin: const EdgeInsets.only(
                                  bottom: 10.0, left: 30.0, right: 30.0),
                              child: field,
                            ))
                        .toList()
                        .sublist(3, 5),
                  ),
                  CheckboxListTile(
                    title: const Text(
                        "I agree to the processing of personal data"),
                    value: isChecked,
                    onChanged: (newValue) {
                      setState(() {
                        isChecked = true;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment(0.8, 1.0),
                        colors: <Color>[
                          Color(0xff1f005c),
                          Color(0xff5b0060),
                          Color(0xff870160),
                          Color(0xffac255e),
                          Color(0xffca485c),
                          Color(0xffe16b5c),
                          Color(0xfff39060),
                          Color(0xffffb56b),
                        ],
                        tileMode: TileMode.mirror,
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Auth().registerWithEmailAndPassword(
                            _emailController.value.text,
                            _passwordController.value.text);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 25.0),
                        child: Text(
                          "Finish".toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 8.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Have an Account',
                        style: TextStyle(
                          fontSize: 18.0,
                          decoration: TextDecoration.underline,
                          fontFamily: 'Montserrat',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
