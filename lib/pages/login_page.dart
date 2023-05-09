import 'package:flutter/material.dart';
import 'package:event_creater/entities/stylized_field.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E6E6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Sign Up',
                style: TextStyle(
                  fontFamily: 'Khand',
                  fontSize: 80.0,
                )),
            StylizedField(hintText: 'Phone or Email', isObscure: false),
            StylizedField(hintText: 'Password', isObscure: true),
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
                  Navigator.pushNamed(context, '/registry');
                },
                child: Text(
                  'Registry'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 5.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {print('Clicked!')},
        tooltip: 'Forgot password',
        backgroundColor: const Color(0xfff39060),
        child: const Icon(Icons.password),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
