// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'] as int,
    json['name'] as String,
    json['profile_picture'] as String,
    json['oauth_id'] as String,
    json['oauth_service'] as String,
    (json['user_properties'] as List)
        ?.map((e) =>
            e == null ? null : Property.fromJson(e['property'] as Map<String, dynamic>))
        ?.toList(),
  )
    ..birthDate = json['birthDate'] == null
        ? null
        : DateTime.parse(json['birthDate'] as String)
    ..ageMinOffset = json['ageMinOffset'] as int
    ..ageMaxOffset = json['ageMaxOffset'] as int
    ..hasKitchen = json['hasKitchen'] as bool
    ..cookingSkill = (json['cookingSkill'] as num)?.toDouble()
    ..skillMinOffset = (json['skillMinOffset'] as num)?.toDouble()
    ..skillMaxOffset = (json['skillMaxOffset'] as num)?.toDouble()
    ..maxUsers = json['maxUsers'] as int;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile_picture': instance.profilePicture,
      'user_properties': instance.userProperties,
      'oauth_id': instance.oauthId,
      'oauth_service': instance.oauthService,
      'birthDate': instance.birthDate?.toIso8601String(),
      'ageMinOffset': instance.ageMinOffset,
      'ageMaxOffset': instance.ageMaxOffset,
      'hasKitchen': instance.hasKitchen,
      'cookingSkill': instance.cookingSkill,
      'skillMinOffset': instance.skillMinOffset,
      'skillMaxOffset': instance.skillMaxOffset,
      'maxUsers': instance.maxUsers,
    };
