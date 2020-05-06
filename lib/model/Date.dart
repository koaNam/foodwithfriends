import 'package:json_annotation/json_annotation.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/model/Vote.dart';

part 'Date.g.dart';

@JsonSerializable()
class Date{

  int id;
  @JsonKey(name: "user_dates")
  DateTime datetime;
  List<User> users;
  List<Vote> votes;

  Date();

  factory Date.fromJson(Map<String, dynamic> json) => _$DateFromJson(json);

  Map<String, dynamic> toJson() => _$DateToJson(this);
}