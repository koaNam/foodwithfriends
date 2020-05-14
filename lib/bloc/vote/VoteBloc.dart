import 'dart:developer' as developer;

import 'package:tinder_cards/bloc/vote/AbstractVoteBloc.dart';
import 'package:tinder_cards/model/TextVote.dart';
import 'package:tinder_cards/model/User.dart';
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
      String description;

      Vote vote = new TextVote.textVote("dummy", this.text, null, User(userId, null, null, null, null, null), dateId);
      this._planningService.addTextVote(vote);
    }
  }

}