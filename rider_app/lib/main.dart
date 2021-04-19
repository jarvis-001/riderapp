import 'package:flutter/material.dart';
import 'package:rider_app/AllScreens/mainscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "flutter Demo",
      theme: ThemeData(
        primaryColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Mainscreen(),
      debugShowCheckedModeBanner: false,
      
    );
  }
}