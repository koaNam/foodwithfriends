import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/vote/DateVoteBloc.dart';
import 'package:tinder_cards/bloc/vote/VoteBloc.dart';
import 'package:tinder_cards/ui/planning/date/vote/AbstractAddVotePage.dart';
import 'package:tinder_cards/ui/planning/date/vote/AddDateVotePage.dart';
import 'package:tinder_cards/ui/planning/date/vote/AddVotePage.dart';

class AddVotePageWrapper extends StatefulWidget {
  final int dateId;
  final int userId;

  AddVotePageWrapper({this.dateId, this.userId});

  @override
  State<StatefulWidget> createState() {
    return AddVotePageWrapperState();
  }
}

class AddVotePageWrapperState extends State<AddVotePageWrapper> with SingleTickerProviderStateMixin{

  final List<AbstractAddVotePage> addVotePages = new List();
  int index = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(vsync: this, length: 2);
    this.addVotePages.add(AddVotePage(new VoteBloc(), widget.dateId, widget.userId));
    this.addVotePages.add(AddDateVotePage(new DateVoteBloc(), widget.dateId, widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade200,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          bottom: TabBar(
            indicatorColor: Color(0xFF3a5fb6),
            labelStyle: TextStyle(fontSize: 20),
            labelColor: Colors.black,
            controller: _tabController,
            tabs: <Widget>[
              Tab(text: "Text",),
              Tab(text: "Termin",)
            ],
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                this.addVotePages[this.index].onSubmit();
                Navigator.of(context).pop();
              },
              child: Text("weiter", style: TextStyle(color: Colors.black, fontSize: 18),),
            )
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: this.addVotePages
        ),
    );
  }

}
