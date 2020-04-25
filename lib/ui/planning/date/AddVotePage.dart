import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/VoteBloc.dart';
import 'package:tinder_cards/ui/planning/date/AbstractAddVotePage.dart';

class AddVotePage extends StatelessWidget implements AbstractAddVotePage{

  final VoteBloc voteBloc;
  final int dateId;
  final int userId;

  AddVotePage({this.voteBloc, this.dateId, this.userId});

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
          voteBloc.text = text
        },
      ),
    );
  }

  @override
  void onSubmit() {
    voteBloc.addVote(this.dateId, this.userId);
  }

}