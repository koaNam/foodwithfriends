import 'package:json_annotation/json_annotation.dart';

import 'Voter.dart';

part 'Vote.g.dart';

@JsonSerializable()
class Vote{

  int id;
  String title;
  String description;
  List<Voter> voters;

  Vote();

  factory Vote.fromJson(Map<String, dynamic> json) => _$VoteFromJson(json);

  Map<String, dynamic> toJson() => _$VoteToJson(this);

}