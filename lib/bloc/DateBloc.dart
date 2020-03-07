import 'package:rxdart/rxdart.dart';
import 'package:tinder_cards/model/Date.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/service/PlanningService.dart';
import 'package:tinder_cards/service/graphql/field.dart';

import 'dart:developer' as developer;

import 'package:tinder_cards/service/graphql/mutation.dart';

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
    this._dateController.add(date);
  }

  Future<void> addVote(int dateId) async{
    developer.log("adding vote", name: LOG);
  }

  Future<void> vote(int dateId, int voteId, int userId, String vote, bool isUpvote) async{
    if(isUpvote) {
      developer.log("vote", name: LOG);
      await this._planningService.addVote(voteId, userId, vote);
      this.loadDate(dateId);
    }else{
      await this._planningService.deleteVote(voteId, userId);
      this.loadDate(dateId);
    }
  }

  Future<List<User>> loadUsers(int dateId) async{
    developer.log("loading date users", name: LOG);
    Date date = await this._planningService.getDateWithUsers(dateId);
    return date.users;
  }

}