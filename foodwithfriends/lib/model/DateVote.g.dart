// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DateVote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateVote _$DateVoteFromJson(Map<String, dynamic> json) {
  return DateVote()
    ..id = json['id'] as int
    ..result = json['result'] as String
    ..sourceUser = json['source_user'] == null
        ? null
        : User.fromJson(json['source_user'] as Map<String, dynamic>)
    ..dateId = json['date_id'] as int
    ..voters = (json['voters'] as List)
        ?.map(
            (e) => e == null ? null : Voter.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..datetime = DateTime.parse(json['date_votes'][0]['datetime'] as String)
    ..voteKind = json['vote_kind'] as String;
}

Map<String, dynamic> _$DateVoteToJson(DateVote instance) => <String, dynamic>{
      'id': instance.id,
      'result': instance.result,
      'source_user': instance.sourceUser,
      'date_id': instance.dateId,
      'voters': instance.voters,
      'date_votes': {
        'data': {
          'datetime': instance.datetime.toIso8601String(),
        }
      },
      'vote_kind': instance.voteKind,
    };
