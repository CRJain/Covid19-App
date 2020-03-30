import 'package:covid19/views/chartview.dart';
import 'package:covid19/views/homepageview.dart';
import 'package:covid19/views/mapview.dart';
import 'package:flutter/material.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomePageView()
    );
  }
}
