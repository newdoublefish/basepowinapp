import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'base_bean.dart';
part 'user_bean.g.dart';

@JsonSerializable(nullable: false)
class UserBean extends BaseBean{
  String username;
  String first_name;
  String last_name;
  String email;
  String password;
  bool is_superuser;
  bool is_staff;
  bool is_active;
  bool is_admin;
  String mobile;
  int position;
  String position_text;
  int organ;
  String organ_text;
  int unit;
  String unit_text;

  UserBean();

  factory UserBean.fromJson(Map<String, dynamic> json) => _$UserBeanFromJson(json);
  Map<String, dynamic> toJson() => _$UserBeanToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "UserBean : {id:$id, organ:$organ, unit:$unit, postion:$position,$organ_text,$unit_text,$position_text}";
  }

}