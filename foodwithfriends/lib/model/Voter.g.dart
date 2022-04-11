// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Voter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Voter _$VoterFromJson(Map<String, dynamic> json) {
  return Voter()
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..vote = json['vote'] as String;
}

Map<String, dynamic> _$VoterToJson(Voter instance) => <String, dynamic>{
      'user': instance.user,
      'vote': instance.vote,
    };
