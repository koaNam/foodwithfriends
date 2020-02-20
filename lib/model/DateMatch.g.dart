// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DateMatch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DateMatch _$DateMatchFromJson(Map<String, dynamic> json) {
  return DateMatch()
    ..id = int.parse(json['id'])
    ..users = (json['userDateMatches'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e['user'] as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$DateMatchToJson(DateMatch instance) => <String, dynamic>{
      'userDateMatches': instance.users,
    };
