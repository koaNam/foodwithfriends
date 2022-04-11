import 'package:rxdart/rxdart.dart';
import 'package:foodwithfriends/model/Date.dart';
import 'package:foodwithfriends/model/DateVote.dart';
import 'package:foodwithfriends/model/TextVote.dart';
import 'package:foodwithfriends/model/User.dart';
import 'package:foodwithfriends/service/PlanningService.dart';

import 'dart:developer' as developer;


class DateBloc{
  static const String LOG="bloc.DateBloc";

  BehaviorSubject<Date> _dateController = BehaviorSubject<Date>();
  Observable<Date> get dateStream =>_dateController.stream;

  PlanningService _planningService;

  DateBloc(){
    this._planningService = new PlanningService();
  }

  Future<void> loadDate(int dateId) async{
    developer.log("loading date", name: LOG);

    Date date = await this._planningService.getDate(dateId);
    List<TextVote> textVotes= await this._planningService.getTextVotes(dateId);
    List<DateVote> dateVotes= await this._planningService.getDateVotes(dateId);
    date.votes = new List.from(dateVotes);
    date.votes.addAll(textVotes);
    this._dateController.add(date);
  }

  Future<void> vote(int dateId, int voteId, int userId, String vote, bool isNewVote) async{
    if(isNewVote) {
      developer.log("vote", name: LOG);
      await this._planningService.vote(voteId, userId, vote);
    }else{
      developer.log("delete old vote", name: LOG);
      await this._planningService.deleteVote(voteId, userId);
    }
    this.loadDate(dateId);
  }

  Future<List<User>> loadUsers(int dateId) async{
    developer.log("loading date users", name: LOG);
    Date date = await this._planningService.getDateWithUsers(dateId);
    return date.users;
  }

}