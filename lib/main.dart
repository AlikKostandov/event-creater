import 'package:flutter/material.dart';
import 'package:event_creater/pages/login_page.dart';
import 'package:event_creater/pages/registry_page.dart';

void main() =>
    runApp(MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xff5b0060),
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: const Color(0xffffb56b)),
          primarySwatch: Colors.deepOrange,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const Login(),
          '/registry': (context) => const Registry(),
        }
    ));