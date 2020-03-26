import 'dart:developer' as developer;

import 'package:tinder_cards/model/Vote.dart';
import 'package:tinder_cards/service/PlanningService.dart';


class VoteBloc{
  static const String LOG="bloc.VoteBloc";

  String text;

  PlanningService _planningService;

  VoteBloc(){
    this._planningService = new PlanningService();
  }

  Future<void> addVote(int dateId, int userId) async{
    if(this.text!= null) {
      developer.log("adding vote", name: LOG);
      int titleEnd = text.indexOf("\n");
      String title;
      String description;
      if (titleEnd >= 0) {
        title = text.substring(0, titleEnd);
        description = text.substring(
            titleEnd + 1, text.length); // +1 um "/n" zu überspringen
      } else {
        title = text;
        description = "";
      }

      print(title);
      print(description);

      Vote vote = new Vote.vote(title, description, userId, dateId);
      this._planningService.addVote(vote);
    }
  }

}