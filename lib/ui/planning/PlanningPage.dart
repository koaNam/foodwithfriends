import 'package:flutter/material.dart';
import 'package:tinder_cards/ui/planning/chat/ChatPage.dart';
import 'package:tinder_cards/ui/planning/DateListElement.dart';

class PlanningPage extends StatelessWidget {

  final int userId;

  PlanningPage({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Matches",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Container(
          color: Colors.grey.shade100,
            child: ListView(
              children: <Widget>[
                DateListElement(userId: this.userId)
              ],
            )
        )
    );
  }
}
