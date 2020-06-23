import 'package:json_annotation/json_annotation.dart';
import 'package:foodwithfriends/model/User.dart';

import 'Vote.dart';
import 'Voter.dart';

part 'DateVote.g.dart';

@JsonSerializable()
class DateVote extends Vote{

  DateTime datetime;
  @JsonKey(name: "vote_kind")
  String voteKind = "DATE";

  DateVote();

  DateVote.dateVote(this.datetime, String result, User sourceUser, int dateId): super.vote(result, sourceUser, dateId);

  factory DateVote.fromJson(Map<String, dynamic> json) => _$DateVoteFromJson(json);

  Map<String, dynamic> toJson() => _$DateVoteToJson(this);

}