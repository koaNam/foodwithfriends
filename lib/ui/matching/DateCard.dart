import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/MatchingBloc.dart';
import 'package:tinder_cards/model/DateMatch.dart';
import 'package:tinder_cards/model/User.dart';

import 'SuggestionCard.dart';


class DateCard extends StatelessWidget implements SuggestionCard{

  final MatchingBloc matchingBloc;

  final int myId;
  final DateMatch dateMatch;
  final Function() accept;
  final Function() decline;

  DateCard({this.dateMatch, this.accept, this.decline, this.matchingBloc, this.myId});

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: Column(children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                new GridView.count(
                  crossAxisCount: 2,
                  children: this._buildPictures(this.dateMatch.users)
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
              ],
            ),
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



  @override
  void onSwipeLeft() {
    print("left from date");
    this.matchingBloc.addDateMatch(this.myId, this.dateMatch.id);
  }

  @override
  void onSwipeRight() {
    print("right from date");
  }

  List<Widget> _buildPictures(List<User> users) {
    List<Widget> widgets = new List();
    for (User user in users) {
      widgets.add(new Image.network(user.profilePicture, fit: BoxFit.cover),);
    }
    return widgets;
  }

}