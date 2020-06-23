import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:foodwithfriends/model/Property.dart';
import 'package:foodwithfriends/service/graphql/ConditionElement.dart';

import 'package:foodwithfriends/service/graphql/condition.dart';
import 'package:foodwithfriends/service/graphql/field.dart';
import 'package:foodwithfriends/service/graphql/graph.dart';
import 'package:foodwithfriends/service/graphql/mutation.dart';

import 'dart:convert' as convert;

import 'graphql/ConditionElementList.dart';
import 'graphql/graphql_constants.dart';

class PropertyService{

  Future<List<Property>> findLikeName(String likeName) async{
    Graph graph = Graph("property")
        .add(Field("id"))
        .add(Field("name"))
        .add(Field("colour"))
      .condition(Condition.element(ConditionElement<String>(Field("name"), Condition.ILIKE, likeName)));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: graph.build(),
        headers: GraphQlConstants.HEADERS);
    if(result.statusCode == HttpStatus.ok) {
      List<Property> resultList=new List();

      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      for(Map<String, dynamic> prop in resultMap["data"]["property"]){
        resultList.add(Property.fromJson(prop));
      }
      return resultList;
    }
    return null;  //TODO throw exception
  }

  Future<List<Property>> findByIdInList(List<int> ids) async{
    ConditionElementList conditionList = new ConditionElementList(ConditionElementList.OR);
    for(int id in ids){
      conditionList.addConditionElement(ConditionElement<int>(Field("id"), Condition.EQUALS, id));
    }

    Graph graph = Graph("property")
        .add(Field("id"))
        .add(Field("name"))
        .add(Field("colour"))
        .condition(Condition.element(conditionList));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: graph.build(),
        headers: GraphQlConstants.HEADERS);
    if(result.statusCode == HttpStatus.ok) {
      List<Property> resultList=new List();

      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      for(Map<String, dynamic> prop in resultMap["data"]["property"]){
        resultList.add(Property.fromJson(prop));
      }
      return resultList;
    }
    return null;  //TODO throw exception
  }


  Future<int> findMaxId() async{
    Graph graph = Graph("property_aggregate")
        .add(Graph("aggregate")
          .add(Graph("max")
            .add(Field("id"))
        )
    );

    http.Response result = await http.post(
        GraphQlConstants.URL, body: graph.build(),
        headers: GraphQlConstants.HEADERS);
    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      return resultMap["data"]["property_aggregate"]["aggregate"]["max"]["id"];
    }
    return null;
  }

  Future<void> addUserProperty(int userId, int propertyId) async{
    Map<String, int> objects=new Map();
    objects["user_id"] = userId;
    objects["property_id"] = propertyId;
    
    Mutation mutation=new Mutation("insert_user_property", Mutation.INSERT)
      .addObjects(convert.jsonEncode(objects))
      .addReturning(Field("user_id"))
      .addReturning(Field("property_id"));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: mutation.build(),
        headers: GraphQlConstants.HEADERS);
    if(result.statusCode == HttpStatus.ok) {
      return;
    }else {
      return; //TODO throw exception
    }
  }

  Future<void> deleteUserProperty(int userId, int propertyId) async{
    Map<String, dynamic> id=new Map();
    id["_eq"]=userId;
    Map<String, dynamic> where=new Map();
    where["user_id"]=id;

    Map<String, dynamic> and=new Map();
    and["_eq"]=propertyId;
    Map<String, dynamic> andWhere=new Map();
    andWhere["property_id"]=and;

    where["_and"]=andWhere;

    Mutation mutation = Mutation("delete_user_property", Mutation.DELETE)
        .addObjects("where: ${convert.json.encode(where)}")
        .addReturning(Field("user_id"))
        .addReturning(Field("property_id"));

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
