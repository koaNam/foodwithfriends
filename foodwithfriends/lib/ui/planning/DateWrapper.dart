import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodwithfriends/AppTheme.dart';
import 'package:foodwithfriends/ui/planning/chat/ChatPage.dart';
import 'package:foodwithfriends/ui/planning/date/DatePage.dart';

class DateWrapper extends StatefulWidget{

  final int userId;
  final int dateId;

  DateWrapper(this.userId, this.dateId);

  @override
  State<StatefulWidget> createState() {
    return DateWrapperState();
  }
}

class DateWrapperState extends State<DateWrapper> with SingleTickerProviderStateMixin {

  TabController _tabController;
  int index=0;

  @override
  void initState() {
    super.initState();
    this._tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: TabBar(
          indicatorColor: AppTheme.MAIN_COLOR,
          labelPadding: EdgeInsets.only(top: 12),
          indicatorWeight: 6,
          labelStyle: TextStyle(fontSize: 20),
          labelColor: Colors.black,
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: "Votes",),
            Tab(text: "Chat",)
          ],
        )
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          DatePage(userId: widget.userId, dateId: widget.dateId),
          ChatPage(userId: widget.userId, dateId: widget.dateId)
        ],
      ),
    );
  }
}
