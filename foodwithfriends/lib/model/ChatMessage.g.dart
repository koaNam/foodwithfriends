// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChatMessage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return ChatMessage(
    message: json['message'] as String,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'message': instance.message,
      'user': instance.user,
    };
