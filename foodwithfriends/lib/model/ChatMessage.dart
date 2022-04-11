import 'package:json_annotation/json_annotation.dart';

import 'User.dart';

part 'ChatMessage.g.dart';

@JsonSerializable()
class ChatMessage{

  String message;
  User user;

  ChatMessage({this.message, this.user});

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

}