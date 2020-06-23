import 'package:json_annotation/json_annotation.dart';
import 'package:foodwithfriends/model/User.dart';

part 'Voter.g.dart';

@JsonSerializable()
class Voter{

  User user;
  String vote;

  Voter();

  factory Voter.fromJson(Map<String, dynamic> json) => _$VoterFromJson(json);

  Map<String, dynamic> toJson() => _$VoterToJson(this);

}