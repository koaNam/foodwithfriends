import 'package:flutter/material.dart';
import 'package:foodwithfriends/bloc/MatchingBloc.dart';
import 'package:foodwithfriends/model/DateMatch.dart';
import 'package:foodwithfriends/model/User.dart';

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
        margin: EdgeInsets.only(bottom: 60, top: 10),
        child: Column(children: <Widget>[
          Expanded(
            child: ClipRRect(
              child: GridView.count(
                  crossAxisCount: 2,
                  children: this._buildPictures(this.dateMatch.users)
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(6.0),
                topRight: Radius.circular(6.0),
              )
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
        ]
      )
    );
  }



  @override
  void onSwipeLeft() {
    this.matchingBloc.setDateMatchStatus(this.myId, this.dateMatch.id, true);
  }

  @override
  void onSwipeRight() {
    this.matchingBloc.setDateMatchStatus(this.myId, this.dateMatch.id, false);
  }

  List<Widget> _buildPictures(List<User> users) {
    List<Widget> widgets = new List();
    for (User user in users) {
      widgets.add(Image.network(user.profilePicture, fit: BoxFit.cover),);
    }
    return widgets;
  }

}
