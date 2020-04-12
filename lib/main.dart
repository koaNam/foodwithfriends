import 'package:flutter/material.dart';

import 'Home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return new MaterialApp
    (
      title: 'FoodWithFriends',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new Home(),
    );
  }
}