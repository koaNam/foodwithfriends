// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TextVote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextVote _$TextVoteFromJson(Map<String, dynamic> json) {
  return TextVote()
    ..id = json['id'] as int
    ..result = json['result'] as String
    ..sourceUserId = json['source_user_id'] as int
    ..dateId = json['date_id'] as int
    ..voteKind = json['vote_kind'] as String
    ..voters = (json['voters'] as List)
        ?.map(
            (e) => e == null ? null : Voter.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..title = json['text_votes'][0]['title'] as String
    ..description = json['text_votes'][0]['description'] as String;
}

Map<String, dynamic> _$TextVoteToJson(TextVote instance) => <String, dynamic>{
      'id': instance.id,
      'result': instance.result,
      'source_user_id': instance.sourceUserId,
      'vote_kind': instance.voteKind,
      'text_votes': {
        'data': {
          'id': instance.id,
          'title': instance.title,
          'description': instance.description
        }
      },
      'date_id': instance.dateId,
      'voters': instance.voters,
    };
