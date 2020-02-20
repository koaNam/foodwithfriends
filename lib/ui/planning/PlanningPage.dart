import 'package:flutter/material.dart';
import 'package:tinder_cards/ui/planning/chat/ChatPage.dart';
import 'package:tinder_cards/ui/planning/DateListElement.dart';

class PlanningPage extends StatelessWidget {

  final int userId;

  PlanningPage({this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Matches"), centerTitle: true,),
        body: Container(
            child: ListView(
              children: <Widget>[
                DateListElement(dateId: 1, userId: this.userId)
              ],
            )
        )
    );
  }
}
