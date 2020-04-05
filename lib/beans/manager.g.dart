// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Manager _$ManagerFromJson(Map<String, dynamic> json) {
  return Manager()
    ..id = json['id'] as int
    ..organization = json['organization'] as int
    ..user = json['user'] as int
    ..username = json['username'] as String;
}

Map<String, dynamic> _$ManagerToJson(Manager instance) => <String, dynamic>{
      'id': instance.id,
      'organization': instance.organization,
      'user': instance.user,
      'username': instance.username
    };
