import 'package:json_annotation/json_annotation.dart';
import 'package:tinder_cards/model/User.dart';

import 'Voter.dart';

part 'Vote.g.dart';

@JsonSerializable()
class Vote{

  int id;
  String title;
  String description;
  String result;
  @JsonKey(name: "source_user_id")
  int sourceUserId;
  @JsonKey(name: "date_id")
  int dateId;
  List<Voter> voters;

  Vote();

  Vote.vote(this.title, this.description, this.result, this.sourceUserId, this.dateId);

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);

  Map<String, dynamic> toJson() => _$VoteToJson(this);

}