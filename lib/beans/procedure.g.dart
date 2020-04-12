// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'procedure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Procedure _$ProcedureFromJson(Map<String, dynamic> json) {
  return Procedure()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..mop = json['mop'] as int
    ..mop_name = json['mop_name'] as String
    ..part_no_name = json['part_no_name'] as String
    ..parent = json['parent'] as int
    ..dept = json['dept'] as int
    ..dept_name = json['dept_name'] as String
    ..quantity = json['quantity'] as int
    ..received_quantity = json['received_quantity'] as int
    ..delivered_quantity = json['delivered_quantity'] as int
    ..remake_quantity = json['remake_quantity'] as int
    ..status = json['status'] as int
    ..status_name = json['status_name'] as int
    ..created_at = json['created_at'] as String
    ..updated_at = json['updated_at'] as String;
}

Map<String, dynamic> _$ProcedureToJson(Procedure instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mop': instance.mop,
      'mop_name': instance.mop_name,
      'part_no_name': instance.part_no_name,
      'parent': instance.parent,
      'dept': instance.dept,
      'dept_name': instance.dept_name,
      'quantity': instance.quantity,
      'received_quantity': instance.received_quantity,
      'delivered_quantity': instance.delivered_quantity,
      'remake_quantity': instance.remake_quantity,
      'status': instance.status,
      'status_name': instance.status_name,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at
    };
