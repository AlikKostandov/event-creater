import 'dart:io';

import 'package:event_creater/entity/simple_user.dart';
import 'package:event_creater/widgets/stylized_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:event_creater/widgets/header_widget.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../auth.dart';

class Registry extends StatefulWidget {
  const Registry({super.key});

  @override
  _RegistryState createState() => _RegistryState();
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _nameController = TextEditingController();
final TextEditingController _surnameController = TextEditingController();
final TextEditingController _birthController = TextEditingController();

// Setting the basic parameters for the text fields of the registration form
List<StylizedField> fields = [
  StylizedField.withControllerAndValidator(
      hintText: "Name",
      isObscure: false,
      controller: _nameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Name';
        } else {
          if (value[0] != value[0].toUpperCase()) {
            return 'The name must begin with a capital letter';
          } else {
            return null;
          }
        }
      }),
  StylizedField.withControllerAndValidator(
      hintText: "Surname",
      isObscure: false,
      controller: _surnameController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Surname';
        } else {
          if (value[0] != value[0].toUpperCase()) {
            return 'The surname must begin with a capital letter';
          } else {
            return null;
          }
        }
      }),
  StylizedField.withControllerAndValidator(
      hintText: "Email",
      isObscure: false,
      controller: _emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        } else {
          if (!value.contains("@")) {
            return 'Enter a valid email';
          } else {
            return null;
          }
        }
      }),
  StylizedField.withControllerAndValidator(
    hintText: "Password",
    isObscure: true,
    controller: _passwordController,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please create a password';
      } else {
        if (value.length < 8) {
          return 'The password cant be shorter than 8 characters';
        } else if (!value.contains(RegExp(r'[0-9]'))) {
          return 'The password must contain a digit';
        } else if (!value.contains(RegExp(r'[a-z]'))) {
          return 'The password must contain lowercase';
        } else if (!value.contains(RegExp(r'[A-Z]'))) {
          return 'The password must contain uppercase';
        } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>-]'))) {
          return 'The password must contain special characters';
        } else {
          return null;
        }
      }
    },
  ),
  StylizedField.withValidator(
    hintText: "Repeat a Password",
    isObscure: true,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Repeat a password';
      } else {
        if (value != _passwordController.text) {
          return 'Passwords don\'t match';
        } else {
          return null;
        }
      }
    },
  ),
];

class _RegistryState extends State<Registry> {
  final double _headerHeight = 150;
  final _formKey = GlobalKey<FormState>();
  String? gender;
  bool isChecked = true;
  DateTime currentDate =
      DateTime.now().subtract(const Duration(days: 365 * 18));

  /// Calendar setting function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1950),
        lastDate: DateTime(2024));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        _birthController.text = DateFormat('dd.MM.yyyy').format(currentDate);
      });
    }
  }

  /// The function of user registration in the database
  Future<void> registerUser() async {
    SimpleUser user = SimpleUser(
        name: _nameController.text,
        surname: _surnameController.text,
        gender: gender!,
        birthDt: DateFormat('yyyy-MM-dd').format(currentDate),
        email: _emailController.text);
    var jsonBody = jsonEncode(user.toJson());
    final response = await http.post(
        Uri.parse('http://192.168.1.120:9000/event-creater/users/registry'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonBody);
    if (response.statusCode != 200) {
      throw HttpException;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            SizedBox(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                    child: Text('Sign Up',
                        style: TextStyle(
                            fontFamily: 'Lobster',
                            fontSize: 80.0,
                            fontStyle: FontStyle.italic,
                            wordSpacing: -20)),
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Fields for name, surname and email
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
                        // Field for birthday
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 10.0, left: 30.0, right: 170.0),
                          child: TextFormField(
                            controller: _birthController,
                            readOnly: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your Birthday';
                              }
                            },
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () => _selectDate(context),
                                ),
                                hintText: "Birthdate",
                                hintStyle:
                                    const TextStyle(color: Color(0xFF9F9797)),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.only(left: 20.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1.5, color: Colors.black),
                                  borderRadius: BorderRadius.circular(15.0),
                                )),
                            style: const TextStyle(
                                fontSize: 20.0, fontFamily: 'Mukta'),
                          ),
                        ),
                        // Radios responsible for the users gender
                        Column(
                          children: <Widget>[
                            RadioListTile(
                              activeColor: Colors.blue,
                              contentPadding: const EdgeInsets.only(left: 25.0),
                              title: const Text("Male",
                                  style: TextStyle(
                                      fontFamily: 'Mukta', fontSize: 22.0)),
                              value: "Male",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                });
                              },
                            ),
                            RadioListTile(
                              activeColor: Colors.blue,
                              contentPadding: const EdgeInsets.only(left: 25.0),
                              title: const Text("Female",
                                  style: TextStyle(
                                    fontFamily: 'Mukta',
                                    fontSize: 22.0,
                                  )),
                              value: "Female",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                });
                              },
                            ),
                          ],
                        ),
                        //Fields for password
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
                        // The checkbox responsible for confidentiality
                        CheckboxListTile(
                          title: const Text(
                              "I agree to the processing of personal data"),
                          value: isChecked,
                          onChanged: (newValue) {
                            setState(() {
                              isChecked = !isChecked;
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
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (gender == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('You don\'t choose gender')),
                                  );
                                } else if (isChecked == false) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'You must allow us to process your personal data')),
                                  );
                                } else {
                                  try {
                                    await Auth().registerWithEmailAndPassword(
                                        _emailController.value.text,
                                        _passwordController.value.text);
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'email-already-in-use') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'The account already exists for that email')),
                                      );
                                    }
                                  }
                                  try {
                                    await registerUser();
                                  } on HttpException {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Failed to save the user. Try again later')),
                                    );
                                  }
                                }
                              }
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
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                                color: Colors.blue,
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
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
