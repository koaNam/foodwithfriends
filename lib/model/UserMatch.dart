import 'package:json_annotation/json_annotation.dart';
import 'package:foodwithfriends/model/DrawableCard.dart';
import 'package:foodwithfriends/model/User.dart';

part 'UserMatch.g.dart';


@JsonSerializable()
class UserMatch implements DrawableCard{

  int id;

  User match;

  UserMatch();

  factory UserMatch.fromJson(Map<String, dynamic> json) => _$UserMatchFromJson(json);

  Map<String, dynamic> toJson() => _$UserMatchToJson(this);

}