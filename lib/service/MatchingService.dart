import 'dart:io';
import 'dart:async';
import 'dart:core';

import 'package:tinder_cards/model/DateMatch.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/service/graphql/ParameterList.dart';
import 'package:tinder_cards/service/graphql/field.dart';
import 'package:tinder_cards/service/graphql/graph.dart';

import 'package:http/http.dart' as http;
import 'package:tinder_cards/service/graphql/graphql_element.dart';
import 'package:tinder_cards/service/graphql/mutation.dart';
import 'dart:convert' as convert;

import 'graphql/graphql_constants.dart';

class MatchingService {

  static const int COUNT=10;

  Future<List<User>> getMatches(int userId, int innerRadius) async{
    Graph graph=new Graph("matches")
      .add(Field("id"))
      .add(Field("profile_picture"))
      .add(Field("name"))
      .add(Graph("properties")
        .add(Field("name"))
        .add(Field("colour"))
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

  List<User> _buildMatchFromJson(Map<String, dynamic> json){
    List<User> matches=new List();
    for(Map<String, dynamic> data in json["data"]["matches"]){
      User user=User.fromJson(data);
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

  Future<void> addMatch(int userId, int matchId) async {

    Mutation mutation = new Mutation("addMatch", Mutation.NONE)
      .addObjects("userId: $userId, matchId: $matchId")
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
  
  Future<void> addDateMatch(int userId, int dateMatchId) async {
    Mutation mutation=new Mutation("acceptUserDate", Mutation.NONE)
        .addObjects("userId: $userId, dateMatchId: $dateMatchId")
        .addReturning(Graph("users")
          .add(Field("id"))
        );

    print(mutation.build());

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
