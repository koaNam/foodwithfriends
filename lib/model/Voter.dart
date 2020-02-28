import 'package:json_annotation/json_annotation.dart';
import 'package:tinder_cards/model/User.dart';

part 'Voter.g.dart';

@JsonSerializable()
class Voter{

  User user;
  String vote;

  Voter();

  factory Voter.fromJson(Map<String, dynamic> json) => _$VoterFromJson(json);

  Map<String, dynamic> toJson() => _$VoterToJson(this);

}