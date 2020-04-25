import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/VoteBloc.dart';
import 'package:tinder_cards/ui/planning/date/AbstractAddVotePage.dart';
import 'package:tinder_cards/ui/planning/date/AddVotePage.dart';

class AddVotePageWrapper extends StatelessWidget {
  final int dateId;
  final int userId;

  final VoteBloc _voteBloc=new VoteBloc();

  final List<AbstractAddVotePage> addVotePages = new List();
  int index = 0;

  AddVotePageWrapper({this.dateId, this.userId}){
    addVotePages.add(AddVotePage(voteBloc: this._voteBloc, dateId: this.dateId, userId: this.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                this.addVotePages[index].onSubmit();
                Navigator.of(context).pop();
              },
              child: Text("weiter", style: TextStyle(color: Colors.black, fontSize: 18),),
            )
          ],
        ),
        body: PageView(
          onPageChanged: (e) => {
            this.index = e
          },
          scrollDirection: Axis.horizontal,
          children: this.addVotePages,
        )
    );
  }
}
