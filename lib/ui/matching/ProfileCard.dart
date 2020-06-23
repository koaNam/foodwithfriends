import 'dart:core';

import 'package:foodwithfriends/bloc/MatchingBloc.dart';

import 'package:flutter/material.dart';
import 'package:foodwithfriends/model/Property.dart';
import 'package:foodwithfriends/model/UserMatch.dart';

import 'SuggestionCard.dart';

class ProfileCard extends StatelessWidget implements SuggestionCard{

  final MatchingBloc matchingBloc;

  final int myId;
  final UserMatch userMatch;
  final Function() accept;
  final Function() decline;

  ProfileCard({this.userMatch, this.accept, this.decline, this.matchingBloc, this.myId});
  //new BorderRadius.circular(12.0)
  @override
  Widget build(BuildContext context) {
    return new Card(
      margin: EdgeInsets.only(bottom: 60, top: 10),
        child: Column(children: <Widget>[
      Expanded(
        child: Stack(
          children: <Widget>[
            new SizedBox.expand(
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.network(
                      this.userMatch.match.profilePicture,
                      fit: BoxFit.cover),
                )
              ),
            ),
            new SizedBox.expand(
              child: new Container(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.center,
                        end: Alignment.bottomCenter)),
              ),
            ),
            new Align(
              alignment: Alignment.bottomLeft,
              child: new Container(
                  padding: new EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 16.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(this.userMatch.match.name,
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700)),
                      new Padding(padding: new EdgeInsets.only(bottom: 8.0)),
                    ],
                  )),
            )
          ],
        ),
      ),
      Container(
          child: Padding(
        padding: EdgeInsets.only(bottom: 10, top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: () {
                this.decline();
                this.onSwipeRight();
              },
              icon: Icon(Icons.remove_circle_outline),
            ),
            IconButton(
              onPressed: () {
                this.accept();
                this.onSwipeLeft();
              },
              icon: Icon(Icons.cake),
            )
          ],
        ),
      )),
    ]));
  }

  List<Widget> buildProperties(List<Property> properties) {
    List<Widget> widgets = new List();
    if (properties != null) {
      for (Property property in properties) {
        widgets.add(new Center(
          child: Text(property.name),
        ));
      }
    }
    return widgets;
  }

  @override
  void onSwipeLeft() {
    this.matchingBloc.setMatchStatus(this.userMatch.id, true);
  }

  @override
  void onSwipeRight() {
    this.matchingBloc.setMatchStatus(this.userMatch.id, false);
  }

}
