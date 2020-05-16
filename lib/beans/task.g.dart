// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..sub_procedure = json['sub_procedure'] as String
    ..procedure = json['procedure'] as int
    ..procedure_name = json['procedure_name'] as String
    ..plan_quantity = json['plan_quantity'] as int
    ..quantity = json['quantity'] as int
    ..weight = (json['weight'] as num).toDouble()
    ..created_at = json['created_at'] as String
    ..started_at = json['started_at'] as String
    ..stopped_at = json['stopped_at'] as String
    ..user = json['user'] as int
    ..username = json['username'] as String
    ..status_text = json['status_text'] as String;
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sub_procedure': instance.sub_procedure,
      'procedure': instance.procedure,
      'procedure_name': instance.procedure_name,
      'plan_quantity': instance.plan_quantity,
      'quantity': instance.quantity,
      'weight': instance.weight,
      'created_at': instance.created_at,
      'started_at': instance.started_at,
      'stopped_at': instance.stopped_at,
      'user': instance.user,
      'username': instance.username,
      'status_text': instance.status_text
    };
