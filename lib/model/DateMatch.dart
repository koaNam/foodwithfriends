import 'package:json_annotation/json_annotation.dart';
import 'package:foodwithfriends/model/DrawableCard.dart';
import 'package:foodwithfriends/model/User.dart';

part 'DateMatch.g.dart';


@JsonSerializable()
class DateMatch implements DrawableCard{

  int id;

  @JsonKey(name: "userDateMatches")
  List<User> users;

  DateMatch();

  factory DateMatch.fromJson(Map<String, dynamic> json) => _$DateMatchFromJson(json);

  Map<String, dynamic> toJson() => _$DateMatchToJson(this);

}