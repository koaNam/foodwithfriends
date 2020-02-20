import 'dart:core';

import 'package:tinder_cards/bloc/MatchingBloc.dart';

import 'package:flutter/material.dart';
import 'package:tinder_cards/model/Property.dart';
import 'package:tinder_cards/model/User.dart';

import 'SuggestionCard.dart';

class ProfileCard extends StatelessWidget implements SuggestionCard{

  final MatchingBloc matchingBloc;

  final int myId;
  final User user;
  final Function() accept;
  final Function() decline;

  ProfileCard({this.user, this.accept, this.decline, this.matchingBloc, this.myId});

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: Column(children: <Widget>[
      Expanded(
        child: Stack(
          children: <Widget>[
            new SizedBox.expand(
              child: new Material(
                borderRadius: new BorderRadius.circular(12.0),
                child: new Image.network(this.user.profilePicture,
                    fit: BoxFit.cover),
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
                      new Text(this.user.name,
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
      GridView.count(
        shrinkWrap: true,
        childAspectRatio: 5,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        children: this.buildProperties(this.user.userProperties),
      ),
      Container(
          child: Padding(
        padding: EdgeInsets.only(bottom: 50, top: 0),
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
    print("left from card");
    this.matchingBloc.addMatch(this.myId, this.user.id);
  }

  @override
  void onSwipeRight() {
    print("right from card");
  }

}
