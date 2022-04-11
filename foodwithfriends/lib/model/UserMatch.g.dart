// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserMatch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMatch _$UserMatchFromJson(Map<String, dynamic> json) {
  return UserMatch()
    ..id = json['id'] as int
    ..match = json['match'] == null
        ? null
        : User.fromJson(json['match'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UserMatchToJson(UserMatch instance) => <String, dynamic>{
      'id': instance.id,
      'match': instance.match,
    };
