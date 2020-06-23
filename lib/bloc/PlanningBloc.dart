import 'package:rxdart/rxdart.dart';
import 'package:foodwithfriends/model/Date.dart';

import 'dart:developer' as developer;

import 'package:foodwithfriends/service/PlanningService.dart';

class PlanningBloc{

  static const String LOG="bloc.PlanningBloc";

  BehaviorSubject<List<Date>> _dateListController = BehaviorSubject<List<Date>>();
  Observable<List<Date>> get dateListStream =>_dateListController.stream;

  PlanningService _planningService;

  PlanningBloc(){
    this._planningService = new PlanningService();
  }

  Future<void> loadDates(int userId) async{
    developer.log("getting Dates", name: LOG);

    List<Date> dates=await this._planningService.getDates(userId);

    this._dateListController.add(dates);
  }
  
}