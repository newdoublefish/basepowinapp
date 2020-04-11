import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'base_bean.dart';
part 'user_bean.g.dart';

@JsonSerializable(nullable: false)
class UserBean extends BaseBean{
  String username;
  String name;
  String mobile;
  String password;
  String first_name;
  String last_name;
  bool is_superuser;
  bool is_staff;
  bool is_active;
  int dept;
  String dept_name;
  int role;
  String role_name;

  UserBean();

  factory UserBean.fromJson(Map<String, dynamic> json) => _$UserBeanFromJson(json);
  Map<String, dynamic> toJson() => _$UserBeanToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "UserBean : {id:$id, role_name:$role_name, dept_name:$dept_name,dept:$dept}";
  }

}