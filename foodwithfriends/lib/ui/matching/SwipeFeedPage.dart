import 'package:flutter/material.dart';
import 'package:foodwithfriends/bloc/MatchingBloc.dart';
import 'package:foodwithfriends/model/DrawableCard.dart';
import 'package:foodwithfriends/model/User.dart';
import 'package:foodwithfriends/model/UserMatch.dart';
import 'DateCard.dart';
import 'CardsSection.dart';
import 'ProfileCard.dart';

class SwipeFeedPage extends StatelessWidget {

  final int userId;
  final MatchingBloc _matchingBloc=new MatchingBloc();

  SwipeFeedPage({this.userId}){
    _matchingBloc.loadMatchIntoStream(this.userId, 0);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _matchingBloc.matchingStream,
      builder: (context, AsyncSnapshot snap){
        Widget body;
        if(snap.connectionState == ConnectionState.active) {
          List<DrawableCard> data=snap.data;
          body = Scaffold(
            body: Container(
              color: Colors.grey.shade100,
              child:  SafeArea(
                child: Flex(
                  direction: Axis.vertical,
                  children: <Widget>[
                    new CardsSection(
                      context: context,
                      loadThreshold: 2,
                      onLoadData: (lastElement) async {
                        List<DrawableCard> matches = await this._matchingBloc.loadMatch(this.userId, 10); //TODO innerRadius
                        return matches;
                      },
                      itemBuilder: (DrawableCard drawable, Function accept, Function decline) {
                        if(drawable is UserMatch) {
                          return new ProfileCard(userMatch: drawable, accept: accept, decline: decline, matchingBloc: this._matchingBloc, myId: this.userId,);
                        } else {
                          return new DateCard(dateMatch: drawable, accept: accept, decline: decline, matchingBloc: this._matchingBloc, myId: this.userId,);
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        }else{
          body = Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
            body: body
        );
      }
    );
  }
}

