import 'package:flutter/material.dart';
import 'package:tinder_cards/AppTheme.dart';
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
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppTheme.MAIN_COLOR,
              width: 2
            ),
          ),
          hintText: "Gib hier deinen Vorschlag für das Treffen ein und lasse die anderen darüber abstimmen",
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