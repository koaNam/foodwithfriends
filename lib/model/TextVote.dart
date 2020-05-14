import 'package:json_annotation/json_annotation.dart';
import 'package:tinder_cards/model/User.dart';
import 'package:tinder_cards/model/Vote.dart';
import 'Voter.dart';

part 'TextVote.g.dart';

@JsonSerializable()
class TextVote extends Vote{

  String title;
  String description;
  @JsonKey(name: "vote_kind")
  String voteKind = "TEXT";

  TextVote();


  TextVote.textVote(this.title, this.description, String result, User sourceUser, int dateId): super.vote(result, sourceUser, dateId);

  factory TextVote.fromJson(Map<String, dynamic> json) => _$TextVoteFromJson(json);

  Map<String, dynamic> toJson() => _$TextVoteToJson(this);

}