import 'package:flutter/material.dart';

class DatePage extends StatelessWidget{

  final int dateId;
  final int userId;

  DatePage({this.dateId, this.userId});

  @override
  Widget build(BuildContext context) {
    return Text(this.dateId.toString());
  }

}