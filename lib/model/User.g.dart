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
    json['oauth_id'] as int,
    json['oauth_service'] as String,
    (json['user_properties'] as List)
        ?.map((e) =>
            e == null ? null : Property.fromJson(e['property'] as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile_picture': instance.profilePicture,
      'oauth_id': instance.oauthId,
      'oauth_service': instance.oauthService,
      'user_properties': instance.userProperties,
    };
