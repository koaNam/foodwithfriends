// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Date _$DateFromJson(Map<String, dynamic> json) {
  return Date()
    ..id = json['id'] as int
    ..users = (json['user_dates'] as List)
        ?.map(
            (e) => e == null ? null : User.fromJson(e['user'] as Map<String, dynamic>))
        ?.toList()
    ..votes = (json['votes'] as List)
        ?.map(
            (e) => e == null ? null : Vote.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$DateToJson(Date instance) => <String, dynamic>{
      'id': instance.id,
      'user_dates': instance.users,
      'votes': instance.votes,
    };
