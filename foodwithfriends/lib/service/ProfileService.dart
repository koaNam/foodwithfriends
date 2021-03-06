import 'dart:io';

import 'package:foodwithfriends/model/User.dart';
import 'package:foodwithfriends/service/graphql/ConditionElement.dart';
import 'package:foodwithfriends/service/graphql/condition.dart';
import 'package:foodwithfriends/service/graphql/field.dart';
import 'package:foodwithfriends/service/graphql/graph.dart';
import 'package:foodwithfriends/service/graphql/mutation.dart';
import 'package:location/location.dart';


import 'graphql/graphql_constants.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class ProfileService{

  Future<User> findUserById(int id) async{
    Graph graph=Graph("user")
        .add(Field("id"))
        .add(Field("name"))
        .add(Field("profile_picture"))
        .add(Graph("user_properties")
            .add(Graph("property")
              .add(Field("id"))
              .add(Field("name"))
              .add(Field("colour"))))
        .condition(Condition(Field("id"), Condition.EQUALS, id));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: graph.build(),
        headers: GraphQlConstants.HEADERS);
    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      return _buildUserFromJson(resultMap);
    }
    return null;
  }

  Future<User> findUserSettingsById(int id) async{
    Graph graph=Graph("user")
        .add(Field("id"))
        .add(Field("name"))
        .add(Field("birthDate"))
        .add(Field("ageMinOffset"))
        .add(Field("ageMaxOffset"))
        .add(Field("cookingSkill"))
        .add(Field("skillMinOffset"))
        .add(Field("skillMaxOffset"))
        .add(Field("hasKitchen"))
        .add(Field("maxUsers"))
        .condition(Condition(Field("id"), Condition.EQUALS, id));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: graph.build(),
        headers: GraphQlConstants.HEADERS);
    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      return _buildUserFromJson(resultMap);
    }
    return null;
  }

  Future<User> findUserByName(String name) async{
    Graph graph=Graph("user")
        .add(Field("id"))
        .add(Field("name"))
        .add(Field("profile_picture"))
        .add(Graph("user_properties")
        .add(Graph("property")
        .add(Field("id"))
        .add(Field("name"))
        .add(Field("colour"))))
        .condition(Condition.element(ConditionElement<String>(Field("name"), Condition.EQUALS, name)));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: graph.build(),
        headers: GraphQlConstants.HEADERS);

    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      return _buildUserFromJson(resultMap);
    }
    return null;
  }

  Future<User> findUserByOauth(String id, String service) async{
    Graph graph=Graph("user")
        .add(Field("id"))
        .add(Field("name"))
        .add(Field("profile_picture"))
        .add(Graph("user_properties")
        .add(Graph("property")
        .add(Field("id"))
        .add(Field("name"))
        .add(Field("colour"))))
        .condition(Condition.element(ConditionElement<String>(Field("oauth_service"), Condition.EQUALS, service)).addCondition(ConditionElement<String>(Field("oauth_id"), Condition.EQUALS, id)));

    http.Response result = await http.post(
        GraphQlConstants.URL, body: graph.build(),
        headers: GraphQlConstants.HEADERS);
    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      return _buildUserFromJson(resultMap);
    }
    return null;
  }

  Future<User> insertUser(User user) async{
    Map<String, dynamic> value=user.toJson();
    value.remove("id");
    value.remove("ageMinOffset");
    value.remove("ageMaxOffset");
    value.remove("hasKitchen");
    value.remove("cookingSkill");
    value.remove("skillMinOffset");
    value.remove("skillMaxOffset");
    value.remove("maxUsers");

    Mutation mutation=new Mutation("insert_user", Mutation.INSERT)
        .addObjects(convert.json.encode(value))
        .addReturning(Field("id"));

    print(mutation.build());

    http.Response result = await http.post(
        GraphQlConstants.URL, body: mutation.build(),
        headers: GraphQlConstants.HEADERS);

    if(result.statusCode == HttpStatus.ok) {
      Map<String, dynamic> resultMap = convert.json.decode(result.body);
      if(resultMap.containsKey("errors")){  //TODO throw exception
        return null;
      }
      User user=User.fromJson(resultMap["data"]["insert_user"]["returning"][0]);
      return user;
    }
    return null;
  }

  Future<void> updateLocation(User user, LocationData location) async{
    Map<String, dynamic> set=new Map();
    set["longitude"]=location.longitude;
    set["latitude"]=location.latitude;

    Map<String, dynamic> id=new Map();
    id["_eq"]=user.id;

    Map<String, dynamic> where=new Map();
    where["id"]=id;
    
    Mutation mutation = new Mutation("update_user", Mutation.UPDATE)
        .addObjects(convert.jsonEncode(set))
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

  Future<void> updateProfilePicture(int userId, String path) async{
    Map<String, dynamic> set=new Map();
    set["profile_picture"]=GraphQlConstants.S3_URL + path;

    Map<String, dynamic> id=new Map();
    id["_eq"]=userId;

    Map<String, dynamic> where=new Map();
    where["id"]=id;

    Mutation mutation = new Mutation("update_user", Mutation.UPDATE)
        .addObjects(convert.jsonEncode(set))
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

  Future<void> updateProfileSettings(User user) async{
    Map<String, dynamic> set = user.toJson();
    set.remove("id");
    set.remove("profile_picture");
    set.remove("user_properties");
    set.remove("oauth_id");
    set.remove("oauth_service");

    Map<String, dynamic> id=new Map();
    id["_eq"]=user.id;

    Map<String, dynamic> where=new Map();
    where["id"]=id;

    Mutation mutation = new Mutation("update_user", Mutation.UPDATE)
        .addObjects(convert.jsonEncode(set))
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

  _buildUserFromJson(Map<String, dynamic> json){
    if(json["data"]["user"].length > 0){
      User user=User.fromJson(json["data"]["user"][0]);
      return user;
    }
    return null;
  }

}