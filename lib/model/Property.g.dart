// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Property _$PropertyFromJson(Map<String, dynamic> json) {
  return Property(
    json['id'] as int,
    json['name'] as String,
    json['colour'] as String,
  );
}

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'colour': instance.colour,
    };
