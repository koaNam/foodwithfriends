import 'package:rxdart/rxdart.dart';
import 'package:tinder_cards/model/DateMatch.dart';
import 'package:tinder_cards/model/DrawableCard.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/model/UserMatch.dart';
import 'package:tinder_cards/service/MatchingService.dart';
import 'package:tinder_cards/model/Match.dart';

import 'dart:developer' as developer;

import 'package:tinder_cards/service/graphql/mutation.dart';

class MatchingBloc{

  static const String LOG="bloc.MatchingBloc";

  BehaviorSubject<List<DrawableCard>> _matchingController = BehaviorSubject<List<DrawableCard>>();
  Observable<List<DrawableCard>> get matchingStream =>_matchingController.stream;

  MatchingService _matchingService;

  MatchingBloc(){
    _matchingService=new MatchingService();
  }

  Future<void> loadMatch(int userId, int innerRadius) async{
    developer.log("loading matches", name: LOG);

    Future<List<UserMatch>> fMatches=this._matchingService.getMatches(userId, innerRadius);
    Future<List<DateMatch>> fDates= this._matchingService.getDateMatches(userId, innerRadius);

    List<UserMatch> matches=await fMatches;
    List<DateMatch> dates=await fDates;

    List<DrawableCard> matchingCards=new List();
    matchingCards.addAll(dates);
    matchingCards.addAll(matches);

    this._matchingController.add(matchingCards);
  }

  Future<void> setMatchStatus(int matchId, bool status) async {
    developer.log("add match", name: LOG);

    await this._matchingService.setMatchStatus(matchId, status);
  }

  Future<void> setDateMatchStatus(int userId, int dateMatchId, bool status) async {
    developer.log("add date match", name: LOG);

    await this._matchingService.setDateMatchStatus(userId, dateMatchId, status);
  }

}