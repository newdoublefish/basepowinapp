import 'package:json_annotation/json_annotation.dart';
import 'package:manufacture/beans/base_bean.dart';
part 'department.g.dart';

@JsonSerializable(nullable: false)
class Department extends BaseBean {
  String name;

  Department();

  factory Department.fromJson(Map<String, dynamic> json) => _$DepartmentFromJson(json);
  Map<String, dynamic> toJson() => _$DepartmentToJson(this);
}
