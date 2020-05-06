import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/vote/VoteBloc.dart';
import 'package:tinder_cards/ui/planning/date/vote/AbstractAddVotePage.dart';

class AddVotePage extends StatelessWidget implements AbstractAddVotePage{

  final VoteBloc _voteBloc;
  final int dateId;
  final int userId;

  AddVotePage(this._voteBloc, this.dateId, this.userId);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.only(bottom: 40.0),
      child: TextField(
        autofocus: true,
        maxLines: 99,
        decoration: InputDecoration(
          hintText: "Titel\nBeschreibung",
          border: OutlineInputBorder(),
        ),
        onChanged: (text) => {
          _voteBloc.text = text
        },
      ),
    );
  }

  @override
  void onSubmit() {
    _voteBloc.addVote(this.dateId, this.userId);
  }

}