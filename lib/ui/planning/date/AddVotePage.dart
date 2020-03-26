import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/VoteBloc.dart';

class AddVotePage extends StatelessWidget {
  final int dateId;
  final int userId;

  final VoteBloc _voteBloc=new VoteBloc();

  AddVotePage({this.dateId, this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _voteBloc.addVote(this.dateId, this.userId);
                Navigator.of(context).pop();
              },
              child: Text("weiter", style: TextStyle(color: Colors.white, fontSize: 18),),
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.only(bottom: 40.0),
          child: TextField(
            maxLines: 99,
            decoration: InputDecoration(
              hintText: "Titel\nBeschreibung",
              border: OutlineInputBorder(),
            ),
            onChanged: (text) => {
              _voteBloc.text = text
            },
          ),
        ),
    );
  }
}
