// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mop.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mop _$MopFromJson(Map<String, dynamic> json) {
  return Mop()
    ..id = json['id'] as int
    ..sell_order_name = json['sell_order_name'] as String
    ..sell_order = json['sell_order'] as int
    ..manufacture_order_name = json['manufacture_order_name'] as String
    ..manufacture_order = json['manufacture_order'] as int
    ..part_no_name = json['part_no_name'] as String
    ..part_no = json['part_no'] as int
    ..quantity = json['quantity'] as int
    ..status = json['status'] as int
    ..status_name = json['status_name'] as String
    ..created_at = json['created_at'] as String
    ..updated_at = json['updated_at'] as String;
}

Map<String, dynamic> _$MopToJson(Mop instance) => <String, dynamic>{
      'id': instance.id,
      'sell_order_name': instance.sell_order_name,
      'sell_order': instance.sell_order,
      'manufacture_order_name': instance.manufacture_order_name,
      'manufacture_order': instance.manufacture_order,
      'part_no_name': instance.part_no_name,
      'part_no': instance.part_no,
      'quantity': instance.quantity,
      'status': instance.status,
      'status_name': instance.status_name,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at
    };
