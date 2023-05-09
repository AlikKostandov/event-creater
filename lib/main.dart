import 'package:flutter/material.dart';
import 'package:event_creater/pages/login_page.dart';
import 'package:event_creater/pages/registry_page.dart';

void main() => runApp(MaterialApp(
    initialRoute: '/login',
    routes: {
      '/login': (context) => const Login(),
      '/registry': (context) => Registry(),
    }
));