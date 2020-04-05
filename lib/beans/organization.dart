import 'package:json_annotation/json_annotation.dart';
import 'base_bean.dart';
part 'organization.g.dart';

@JsonSerializable(nullable: false)
class Position extends BaseBean{
  int unit;
  String name;
  String short;
  String pinyin;

  Position();

  factory Position.fromJson(Map<String, dynamic> json) => _$PositionFromJson(json);
  Map<String, dynamic> toJson() => _$PositionToJson(this);
}


@JsonSerializable(nullable: false)
class Unit extends BaseBean{
  int organization;
  String code;
  String name;
  String short;
  String pinyin;

  Unit();

  factory Unit.fromJson(Map<String, dynamic> json) => _$UnitFromJson(json);
  Map<String, dynamic> toJson() => _$UnitToJson(this);
}

@JsonSerializable(nullable: false)
class Organization extends BaseBean{
  String code;
  String name;
  String short;
  String pinyin;
  bool status;
  String address;
  String contacts;
  String phone;
  String website;
  String email;

  Organization();

  factory Organization.fromJson(Map<String, dynamic> json) => _$OrganizationFromJson(json);
  Map<String, dynamic> toJson() => _$OrganizationToJson(this);
}