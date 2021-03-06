import 'package:json_annotation/json_annotation.dart';
import 'package:foodwithfriends/model/DrawableCard.dart';
import 'package:foodwithfriends/model/Property.dart';


part 'User.g.dart';

@JsonSerializable()
class User{
  int id;
  String name;
  @JsonKey(name: "profile_picture")
  String profilePicture;
  @JsonKey(name: "user_properties")
  List<Property> userProperties;
  @JsonKey(name: "oauth_id")
  String oauthId;
  @JsonKey(name: "oauth_service")
  String oauthService;

  DateTime birthDate;
  int ageMinOffset;
  int ageMaxOffset;
  bool hasKitchen;
  double cookingSkill;
  double skillMinOffset;
  double skillMaxOffset;
  int maxUsers;

  User(this.id, this.name, this.profilePicture, this.oauthId, this.oauthService, this.userProperties);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}