import 'package:flutter/material.dart';
import 'package:tinder_cards/bloc/vote/AbstractVoteBloc.dart';
import 'package:tinder_cards/model/DateVote.dart';
import 'package:tinder_cards/service/PlanningService.dart';

class DateVoteBloc extends AbstractVoteBloc{

  DateTime date = DateTime.now(); // Initial auf heute setzen
  DateTime time = DateTime.now();

  PlanningService _planningService;

  DateVoteBloc(){
    this._planningService = new PlanningService();
  }

  @override
  void addVote(int dateId, int userId) {
    DateTime dateTime = DateTime.utc(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute
    );
    
    DateVote vote = new DateVote.dateVote(dateTime, null, userId, dateId);
    this._planningService.addDateVote(vote);
  }

}