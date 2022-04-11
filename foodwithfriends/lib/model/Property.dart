
import 'package:json_annotation/json_annotation.dart';

part 'Property.g.dart';

@JsonSerializable()
class Property{

  int id;
  String name;
  String colour;

  Property(this.id, this.name, this.colour);

  factory Property.fromJson(Map<String, dynamic> json) => _$PropertyFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyToJson(this);

}