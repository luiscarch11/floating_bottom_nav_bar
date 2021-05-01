import 'package:animations/animation_widget.dart';
import 'package:animations/test_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: TestPage(),
    );
  }
}
