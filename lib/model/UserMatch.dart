import 'package:json_annotation/json_annotation.dart';
import 'package:tinder_cards/model/DrawableCard.dart';
import 'package:tinder_cards/model/User.dart';

part 'UserMatch.g.dart';


@JsonSerializable()
class UserMatch implements DrawableCard{

  int id;

  User match;

  UserMatch();

  factory UserMatch.fromJson(Map<String, dynamic> json) => _$UserMatchFromJson(json);

  Map<String, dynamic> toJson() => _$UserMatchToJson(this);

}