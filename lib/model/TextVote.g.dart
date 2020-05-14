// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TextVote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextVote _$TextVoteFromJson(Map<String, dynamic> json) {
  return TextVote()
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
    ..title = json['text_votes'][0]['title'] as String
    ..description = json['text_votes'][0]['description'] as String
    ..voteKind = json['vote_kind'] as String;
}

Map<String, dynamic> _$TextVoteToJson(TextVote instance) => <String, dynamic>{
      'id': instance.id,
      'result': instance.result,
      'source_user': instance.sourceUser,
      'date_id': instance.dateId,
      'voters': instance.voters,
      'text_votes': {
        'data': {
          'title': instance.title,
          'description': instance.description
        }
      },
      'vote_kind': instance.voteKind,
    };
