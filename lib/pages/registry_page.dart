import 'package:event_creater/widgets/stylized_field.dart';
import 'package:flutter/material.dart';

import 'package:event_creater/widgets/header_widget.dart';
import 'package:flutter/services.dart';

import '../auth.dart';

class Registry extends StatefulWidget {
  const Registry({super.key});

  @override
  _RegistryState createState() => _RegistryState();
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

List<StylizedField> fields = [
  StylizedField.withValidator(
      hintText: "Name",
      isObscure: false,
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
  StylizedField.withValidator(
      hintText: "Surname",
      isObscure: false,
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
  final double _headerHeight = 350;
  final _formKey = GlobalKey<FormState>();
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
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
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
                                  style: TextStyle(
                                      fontFamily: 'Khand', fontSize: 24.0)),
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
                              if (_formKey.currentState!.validate()) {
                                if (gender == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('You don\'t choose gender')),
                                  );
                                } else {
                                  Auth().registerWithEmailAndPassword(
                                      _emailController.value.text,
                                      _passwordController.value.text);
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
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
