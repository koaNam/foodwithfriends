import 'dart:io';

import 'package:tinder_cards/model/Date.dart';
import 'package:tinder_cards/model/DateVote.dart';
import 'package:tinder_cards/model/TextVote.dart';
import 'package:tinder_cards/service/graphql/ConditionElement.dart';
import 'package:tinder_cards/service/graphql/field.dart';
import 'package:tinder_cards/service/graphql/graph.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'graphql/condition.dart';
import 'graphql/graphql_constants.dart';
import 'graphql/mutation.dart';

class PlanningService{

  Future<List<Date>> getDates(int userId) async {
    Graph graph=new Graph("user_date")
      .add(Graph("date")
        .add(Field("id"))
        .add(Field("datetime"))
        .add(Graph("user_dates")
          .add(Graph("user")
            .add(Field("profile_picture")
          )
        )
      )
    ).condition(Condition(Field("user_id"), Condition.EQUALS, userId));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: graph.build(),
        headers: GraphQlConstants.HEADERS);
    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      return this._buildDates(resultMap);
    }
    return null;
  }

  List<Date> _buildDates(Map<String, dynamic> json){
    List<Date> dates=new List();
      for(Map<String, dynamic> date in json["data"]["user_date"]){
        dates.add(Date.fromJson(date["date"]));
      }
    return dates;
  }

  Future<Date> getDate(int dateId) async{
    Graph graph=new Graph("date")
        .add(Field("datetime"))
        .add(Graph("user_dates")
          .add(Graph("user")
            .add(
              Field("profile_picture")
            )
          )
        ).add(Graph("votes")
          .add(Field("id"))
          .add(Field("title"))
          .add(Field("description"))
          .add(Field("result"))
        ).condition(Condition(Field("id"), Condition.EQUALS, dateId));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: graph.build(),
        headers: GraphQlConstants.HEADERS);

    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      Date date = Date.fromJson(resultMap["data"]["date"][0]);
      return date;
    }
    return null;
  }

  Future<List<TextVote>> getTextVotes(int dateId) async{
    Graph graph=Graph("vote")
        .add(Field("id"))
        .add(Graph("text_votes")
          .add(Field("title"))
          .add(Field("description"))
        )
        .add(Field("result"))
        .add(Graph("voters")
          .add(Graph("user")
            .add(Field("id"))
        ).add(Field("vote"))
      ).condition(Condition(Field("date_id"), Condition.EQUALS, dateId)
       .addCondition(ConditionElement<String>(Field("vote_kind"), Condition.EQUALS, "TEXT")));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: graph.build(),
        headers: GraphQlConstants.HEADERS);

    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      List<TextVote> votes = new List();
      for(Map<String, dynamic> data in resultMap["data"]["vote"]){
        votes.add(TextVote.fromJson(data));
      }
      return votes;
    }
    return null;
  }

  Future<List<DateVote>> getDateVotes(int dateId) async{
    Graph graph=Graph("vote")
        .add(Field("id"))
        .add(Graph("date_votes")
          .add(Field("datetime"))
        ).add(Field("result"))
        .add(Graph("voters")
          .add(Graph("user")
            .add(Field("id"))
      ).add(Field("vote"))
    ).condition(Condition(Field("date_id"), Condition.EQUALS, dateId)
        .addCondition(ConditionElement<String>(Field("vote_kind"), Condition.EQUALS, "DATE")));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: graph.build(),
        headers: GraphQlConstants.HEADERS);

    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      List<DateVote> votes = new List();
      for(Map<String, dynamic> data in resultMap["data"]["vote"]){
        votes.add(DateVote.fromJson(data));
      }
      return votes;
    }
    return null;
  }

  Future<void> vote(int voteId, int userId, String vote) async{
    Map<String, dynamic> value = new Map();
    value["user_id"] = userId;
    value["vote_id"] = voteId;
    value["vote"] = vote;

    Mutation mutation = Mutation("insert_voter", Mutation.INSERT)
        .addObjects(convert.json.encode(value))
        .addReturning(Field("id"));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: mutation.build(),
        headers: GraphQlConstants.HEADERS);

    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      if(resultMap.containsKey("errors")){  //TODO throw exception
        return null;
      }
      return;
    }
    return;
  }

  Future<void> deleteVote(int voteId, int userId) async{
    Map<String, dynamic> id=new Map();
    id["_eq"]=userId;
    Map<String, dynamic> where=new Map();
    where["user_id"]=id;

    Map<String, dynamic> and=new Map();
    and["_eq"]=voteId;
    Map<String, dynamic> andWhere=new Map();
    andWhere["vote_id"]=and;

    where["_and"]=andWhere;

    Mutation mutation = Mutation("delete_voter", Mutation.DELETE)
        .addObjects("where: ${convert.json.encode(where)}")
        .addReturning(Field("id"));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: mutation.build(),
        headers: GraphQlConstants.HEADERS);

    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      if(resultMap.containsKey("errors")){  //TODO throw exception
        return null;
      }
      return;
    }
    return;
  }

  Future<Date> getDateWithUsers(int dateId) async{
    Graph graph=new Graph("date")
        .add(Graph("user_dates")
          .add(Graph("user")
            .add(Field("id"))
            .add(Field("name"))
            .add(Field("profile_picture"))
          )
      ).condition(Condition(Field("id"), Condition.EQUALS, dateId));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: graph.build(),
        headers: GraphQlConstants.HEADERS);

    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      Date date = Date.fromJson(resultMap["data"]["date"][0]);
      return date;
    }
    return null;
  }

  Future<void> addTextVote(TextVote vote) async{
    Map<String, dynamic> data=vote.toJson();
    data.remove("id");
    data.remove("voters");

    Mutation mutation = Mutation("insert_vote", Mutation.INSERT)
        .addObjects(convert.json.encode(data))
        .addReturning(Field("id"));
    
   http.Response result = await http.post(
        GraphQlConstants.URL, body: mutation.build(),
        headers: GraphQlConstants.HEADERS);

    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      if(resultMap.containsKey("errors")){  //TODO throw exception
        return null;
      }
      return;
    }
    return;
  }

  Future<void> addDateVote(DateVote vote) async{
    Map<String, dynamic> data=vote.toJson();
    data.remove("id");
    data.remove("voters");

    Mutation mutation = Mutation("insert_vote", Mutation.INSERT)
        .addObjects(convert.json.encode(data))
        .addReturning(Field("id"));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: mutation.build(),
        headers: GraphQlConstants.HEADERS);

    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      if(resultMap.containsKey("errors")){  //TODO throw exception
        return null;
      }
      return;
    }
    return;
  }

}
