import 'package:json_annotation/json_annotation.dart';
import 'package:manufacture/beans/base_bean.dart';
part 'role.g.dart';

@JsonSerializable(nullable: false)
class Role extends BaseBean {
  String name;

  Role();

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
