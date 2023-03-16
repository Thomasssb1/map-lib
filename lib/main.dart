import 'package:flutter/material.dart';

import 'map.dart';
import 'dart:ui';

import 'package:http/http.dart' as http;

void main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: nMapPage(),
      ),
    );
  }
}
