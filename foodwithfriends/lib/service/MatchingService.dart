import 'dart:io';
import 'dart:async';
import 'dart:core';

import 'package:foodwithfriends/model/DateMatch.dart';
import 'package:foodwithfriends/model/UserMatch.dart';
import 'package:foodwithfriends/service/graphql/ParameterList.dart';
import 'package:foodwithfriends/service/graphql/field.dart';
import 'package:foodwithfriends/service/graphql/graph.dart';

import 'package:http/http.dart' as http;
import 'graphql/mutation.dart';
import 'dart:convert' as convert;

import 'graphql/graphql_constants.dart';

class MatchingService {

  static const int COUNT=10;

  Future<List<UserMatch>> getMatches(int userId, int innerRadius) async{
    Graph graph=new Graph("matches")
      .add(Field("id"))
      .add(Graph("match")
        .add(Field("id"))
        .add(Field("profile_picture"))
        .add(Field("name"))
        .add(Graph("properties")
          .add(Field("name"))
          .add(Field("colour"))
      )
    )
    .condition(ParameterList()
      .addParameter("userId", userId.toString())
      .addParameter("innerRadius", "0")
      .addParameter("count", COUNT.toString())
    );

    http.Response result = await http.post(
        GraphQlConstants.URL, body: graph.build(),
        headers: GraphQlConstants.HEADERS);
    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      return _buildMatchFromJson(resultMap);
    }

    return null;
  }

  Future<List<DateMatch>> getDateMatches(int userId, int innerRadius) async{
    Graph graph=new Graph("dateMatches")
      .add(Field("id"))
      .add(Graph("userDateMatches")
        .add(Graph("user")
          .add(Field("name"))
          .add(Field("profile_picture"))
        )
      )
    .condition(ParameterList()
      .addParameter("userId", userId.toString())
      .addParameter("innerRadius", "0")
      .addParameter("count", COUNT.toString())
    );

    http.Response result = await http.post(
        GraphQlConstants.URL, body: graph.build(),
        headers: GraphQlConstants.HEADERS);
    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      return _buildDateMatchFromJson(resultMap);
    }

    return null;
  }

  List<UserMatch> _buildMatchFromJson(Map<String, dynamic> json){
    List<UserMatch> matches=new List();
    for(Map<String, dynamic> data in json["data"]["matches"]){
      UserMatch user=UserMatch.fromJson(data);
      matches.add(user);
    }
    return matches;
  }

  List<DateMatch> _buildDateMatchFromJson(Map<String, dynamic> json){
    List<DateMatch> dateMatches=new List();
    for(Map<String, dynamic> data in json["data"]["dateMatches"]){
      DateMatch dateMatch=DateMatch.fromJson(data);
      dateMatches.add(dateMatch);
    }
    return dateMatches;
  }

  Future<void> setMatchStatus(int matchId, bool status)  async {

    Mutation mutation = new Mutation("setMatchStatus", Mutation.NONE)
      .addObjects("matchId: $matchId, status: $status")
      .addReturning(Field("id"));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: mutation.build(),
        headers: GraphQlConstants.HEADERS);

    if(result.statusCode == HttpStatus.ok) {
      return;
    }else {
      return; //TODO throw exception
    }
  }
  
  Future<void> setDateMatchStatus(int userId, int dateMatchId, bool status) async {
    Mutation mutation=new Mutation("setUserDateStatus", Mutation.NONE)
        .addObjects("userId: $userId, dateMatchId: $dateMatchId, status: $status")
        .addReturning(Graph("users")
          .add(Field("id"))
        );

    http.Response result = await http.post(
        GraphQlConstants.URL, body: mutation.build(),
        headers: GraphQlConstants.HEADERS);
    if(result.statusCode == HttpStatus.ok) {
      return;
    }else {
      return; //TODO throw exception
    }
  }
}
