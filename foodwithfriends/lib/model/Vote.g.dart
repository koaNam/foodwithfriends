// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vote _$VoteFromJson(Map<String, dynamic> json) {
  return Vote()
    ..id = json['id'] as int
    ..result = json['result'] as String
    ..sourceUser = json['source_user'] == null
        ? null
        : User.fromJson(json['source_user'] as Map<String, dynamic>)
    ..dateId = json['date_id'] as int
    ..voters = (json['voters'] as List)
        ?.map(
            (e) => e == null ? null : Voter.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
      'id': instance.id,
      'result': instance.result,
      'source_user': instance.sourceUser,
      'date_id': instance.dateId,
      'voters': instance.voters,
    };
