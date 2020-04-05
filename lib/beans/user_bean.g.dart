// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBean _$UserBeanFromJson(Map<String, dynamic> json) {
  return UserBean()
    ..id = json['id'] as int
    ..username = json['username'] as String
    ..first_name = json['first_name'] as String
    ..last_name = json['last_name'] as String
    ..email = json['email'] as String
    ..password = json['password'] as String
    ..is_superuser = json['is_superuser'] as bool
    ..is_staff = json['is_staff'] as bool
    ..is_active = json['is_active'] as bool
    ..is_admin = json['is_admin'] as bool
    ..mobile = json['mobile'] as String
    ..position = json['position'] as int
    ..position_text = json['position_text'] as String
    ..organ = json['organ'] as int
    ..organ_text = json['organ_text'] as String
    ..unit = json['unit'] as int
    ..unit_text = json['unit_text'] as String;
}

Map<String, dynamic> _$UserBeanToJson(UserBean instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'email': instance.email,
      'password': instance.password,
      'is_superuser': instance.is_superuser,
      'is_staff': instance.is_staff,
      'is_active': instance.is_active,
      'is_admin': instance.is_admin,
      'mobile': instance.mobile,
      'position': instance.position,
      'position_text': instance.position_text,
      'organ': instance.organ,
      'organ_text': instance.organ_text,
      'unit': instance.unit,
      'unit_text': instance.unit_text
    };
