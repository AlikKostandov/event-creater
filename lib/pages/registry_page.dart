import 'package:event_creater/entities/stylized_field.dart';
import 'package:flutter/material.dart';

class Registry extends StatefulWidget {
    const Registry({super.key});

    @override
    _RegistryState createState() => _RegistryState();
}

class _RegistryState extends State<Registry> {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: const Color(0xFFE6E6E6),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                        const Text('Registry',
                            style: TextStyle(
                                fontFamily: 'Khand',
                                fontSize: 80.0,
                            )),
                        StylizedField(hintText: "Name", isObscure: false),
                        StylizedField(hintText: "Surname", isObscure: false),
                        StylizedField(hintText: "Email", isObscure: false),
                        StylizedField(hintText: "Password", isObscure: true),
                        StylizedField(hintText: "Repeat a Password", isObscure: true),
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
                                onPressed: () {},
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
            ), // This trailing comma makes auto-formatting nicer for build methods.
        );
    }
}
