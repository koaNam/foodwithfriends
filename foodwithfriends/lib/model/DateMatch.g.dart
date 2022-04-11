// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DateMatch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateMatch _$DateMatchFromJson(Map<String, dynamic> json) {
  return DateMatch()
    ..id = json['id'] as int
    ..users = (json['userDateMatches'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e['user'] as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$DateMatchToJson(DateMatch instance) => <String, dynamic>{
      'id': instance.id,
      'userDateMatches': instance.users,
    };
