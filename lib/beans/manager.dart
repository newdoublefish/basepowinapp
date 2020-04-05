import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_bean.dart';
part 'manager.g.dart';

@JsonSerializable(nullable: false)
class Manager extends BaseBean{
  int organization;
  int user;
  String username;

  Manager();

  factory Manager.fromJson(Map<String, dynamic> json) => _$ManagerFromJson(json);
  Map<String, dynamic> toJson() => _$ManagerToJson(this);
}