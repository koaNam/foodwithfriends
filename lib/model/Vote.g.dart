// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vote _$VoteFromJson(Map<String, dynamic> json) {
  return Vote()
    ..id = json['id'] as int
    ..title = json['title'] as String
    ..description = json['description'] as String
    ..voters = (json['voters'] as List)
        ?.map(
            (e) => e == null ? null : Voter.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$VoteToJson(Vote instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'voters': instance.voters,
    };
