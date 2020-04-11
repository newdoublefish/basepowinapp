// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Department _$DepartmentFromJson(Map<String, dynamic> json) {
  return Department()
    ..id = json['id'] as int
    ..name = json['name'] as String;
}

Map<String, dynamic> _$DepartmentToJson(Department instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
