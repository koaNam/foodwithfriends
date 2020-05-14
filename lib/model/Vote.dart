import 'package:json_annotation/json_annotation.dart';

import 'User.dart';
import 'Voter.dart';

part 'Vote.g.dart';

@JsonSerializable()
class Vote{

  int id;
  String result;
  @JsonKey(name: "source_user")
  User sourceUser;
  @JsonKey(name: "date_id")
  int dateId;
  List<Voter> voters;

  Vote();

  Vote.vote(this.result, this.sourceUser, this.dateId);

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);

  Map<String, dynamic> toJson() => _$VoteToJson(this);

}