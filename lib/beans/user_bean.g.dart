// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBean _$UserBeanFromJson(Map<String, dynamic> json) {
  return UserBean()
    ..id = json['id'] as int
    ..username = json['username'] as String
    ..name = json['name'] as String
    ..mobile = json['mobile'] as String
    ..password = json['password'] as String
    ..first_name = json['first_name'] as String
    ..last_name = json['last_name'] as String
    ..is_superuser = json['is_superuser'] as bool
    ..is_staff = json['is_staff'] as bool
    ..is_active = json['is_active'] as bool
    ..dept = json['dept'] as int
    ..dept_name = json['dept_name'] as String
    ..role = json['role'] as int
    ..role_name = json['role_name'] as String;
}

Map<String, dynamic> _$UserBeanToJson(UserBean instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'mobile': instance.mobile,
      'password': instance.password,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'is_superuser': instance.is_superuser,
      'is_staff': instance.is_staff,
      'is_active': instance.is_active,
      'dept': instance.dept,
      'dept_name': instance.dept_name,
      'role': instance.role,
      'role_name': instance.role_name
    };
