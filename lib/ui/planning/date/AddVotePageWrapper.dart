import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/vote/DateVoteBloc.dart';
import 'package:tinder_cards/bloc/vote/VoteBloc.dart';
import 'package:tinder_cards/ui/planning/date/AbstractAddVotePage.dart';
import 'package:tinder_cards/ui/planning/date/AddDateVotePage.dart';
import 'package:tinder_cards/ui/planning/date/AddVotePage.dart';

class AddVotePageWrapper extends StatelessWidget {
  final int dateId;
  final int userId;

  final List<AbstractAddVotePage> addVotePages = new List();
  int index = 0;

  AddVotePageWrapper({this.dateId, this.userId}){
    addVotePages.add(AddVotePage(new VoteBloc(), this.dateId, this.userId));
    addVotePages.add(AddDateVotePage(new DateVoteBloc(), this.dateId, this.userId));
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
          dragStartBehavior: DragStartBehavior.down,
          onPageChanged: (e) => {
          FocusScope.of(context).unfocus(),
            this.index = e
          },
          scrollDirection: Axis.horizontal,
          children: this.addVotePages,
        )
    );
  }
}
