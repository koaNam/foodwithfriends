import 'package:flutter/material.dart';

import 'Home.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    precacheImage(AssetImage('assets/start_screen.png'), context);
    return new MaterialApp
    (
      title: 'FoodWithFriends',
      home: new Home(),
    );
  }
}