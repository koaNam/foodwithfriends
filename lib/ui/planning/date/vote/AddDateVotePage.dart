import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tinder_cards/bloc/vote/DateVoteBloc.dart';
import 'package:tinder_cards/ui/planning/date/vote/AbstractAddVotePage.dart';

import 'TimePicker.dart';

class AddDateVotePage extends AbstractAddVotePage{

  final DateVoteBloc _voteBloc;
  final int dateId;
  final int userId;

  AddDateVotePage(this._voteBloc, this.dateId, this.userId);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2 * 0.75,
            child: TimePickerSpinner(
              is24HourMode: true,
              spacing: 50,
              itemHeight: 45,
              highlightedTextStyle: TextStyle(
                fontSize: 23,
                color: Colors.black
              ),
              normalTextStyle: TextStyle(
                  fontSize: 23,
                  color: Colors.black54
              ),
              isForce2Digits: true,
              onTimeChange: (time) {
                this._voteBloc.time = time;
              },
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height / 2 * 0.25,
              margin: EdgeInsets.only(left: 5, right: 5),
              decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.grey, width: 1),
                    bottom: BorderSide(color: Colors.grey, width: 1)
                ),
              ),
              child: InkWell(
                onTap: () async {
                  DateTime now= DateTime.now();
                  DateTime picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: DateTime.now().subtract(Duration(days: 1)),
                    lastDate: DateTime(9999),
                    locale: Locale('de', 'DE'),
                  );
                  this._voteBloc.date = picked;
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Datum"),
                    Text(new DateFormat("dd.MM.yyyy").format(DateTime.now())),
                  ],
                ),
              )
          ),
        ],
      )
    );
  }

  @override
  void onSubmit() {
    this._voteBloc.addVote(this.dateId, this.userId);
  }

}