import 'package:json_annotation/json_annotation.dart';

import 'Vote.dart';

part 'DateVote.g.dart';

@JsonSerializable()
class DateVote extends Vote{

  String datetime;
  @JsonKey(name: "vote_kind")
  String voteKind = "DATE";

  DateVote();

  DateVote.dateVote(this.datetime, String result, int sourceUserId, int dateId): super.vote(result, sourceUserId, dateId);

  factory DateVote.fromJson(Map<String, dynamic> json) => _$DateVoteFromJson(json);

  Map<String, dynamic> toJson() => _$DateVoteToJson(this);

}