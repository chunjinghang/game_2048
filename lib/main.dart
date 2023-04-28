import 'package:flutter/material.dart';
import 'package:game_2048/widget/page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2048',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const GamePage(),
    );
  }
}
