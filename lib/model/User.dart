import 'package:json_annotation/json_annotation.dart';
import 'package:tinder_cards/model/DrawableCard.dart';
import 'package:tinder_cards/model/Property.dart';


part 'User.g.dart';

//@JsonSerializable()
class User implements DrawableCard{
  int id;
  String name;
  @JsonKey(name: "profile_picture")
  String profilePicture;
  @JsonKey(name: "user_properties")
  List<Property> userProperties;

  User(this.id, this.name, this.profilePicture, this.userProperties);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}