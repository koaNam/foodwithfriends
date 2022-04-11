import 'dart:developer' as developer;

import 'package:foodwithfriends/bloc/vote/AbstractVoteBloc.dart';
import 'package:foodwithfriends/model/TextVote.dart';
import 'package:foodwithfriends/model/User.dart';
import 'package:foodwithfriends/model/Vote.dart';
import 'package:foodwithfriends/service/PlanningService.dart';


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

      Vote vote = new TextVote.textVote(this.text, null, User(userId, null, null, null, null, null), dateId);
      this._planningService.addTextVote(vote);
    }
  }

}