import 'dart:developer' as developer;

import 'package:tinder_cards/bloc/vote/AbstractVoteBloc.dart';
import 'package:tinder_cards/model/TextVote.dart';
import 'package:tinder_cards/model/Vote.dart';
import 'package:tinder_cards/service/PlanningService.dart';


class VoteBloc extends AbstractVoteBloc{
  static const String LOG="bloc.VoteBloc";

  String text;

  PlanningService _planningService;

  VoteBloc(){
    this._planningService = new PlanningService();
  }

  Future<void> addVote(int dateId, int userId) async{
    if(this.text!= null) {
      developer.log("adding text vote", name: LOG);
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

      Vote vote = new TextVote.textVote(title, description, null, userId, dateId);
      this._planningService.addTextVote(vote);
    }
  }

}