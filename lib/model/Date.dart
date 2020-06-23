import 'package:json_annotation/json_annotation.dart';
import 'package:foodwithfriends/model/User.dart';
import 'package:foodwithfriends/model/Vote.dart';

part 'Date.g.dart';

@JsonSerializable()
class Date{

  int id;
  @JsonKey(name: "datetime")
  DateTime datetime;
  @JsonKey(name: "user_dates")
  List<User> users;
  List<Vote> votes;

  Date();

  factory Date.fromJson(Map<String, dynamic> json) => _$DateFromJson(json);

  Map<String, dynamic> toJson() => _$DateToJson(this);
}