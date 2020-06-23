import 'package:json_annotation/json_annotation.dart';
import 'package:foodwithfriends/model/User.dart';
import 'package:foodwithfriends/model/Vote.dart';
import 'Voter.dart';

part 'TextVote.g.dart';

@JsonSerializable()
class TextVote extends Vote{

  String description;
  @JsonKey(name: "vote_kind")
  String voteKind = "TEXT";

  TextVote();

  TextVote.textVote(this.description, String result, User sourceUser, int dateId): super.vote(result, sourceUser, dateId);

  factory TextVote.fromJson(Map<String, dynamic> json) => _$TextVoteFromJson(json);

  Map<String, dynamic> toJson() => _$TextVoteToJson(this);

}