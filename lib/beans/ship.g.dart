// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Info _$InfoFromJson(Map<String, dynamic> json) {
  return Info()
    ..name = json['name'] as String
    ..value = json['value'];
}

Map<String, dynamic> _$InfoToJson(Info instance) =>
    <String, dynamic>{'name': instance.name, 'value': instance.value};

ShipModal _$ShipModalFromJson(Map<String, dynamic> json) {
  return ShipModal()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..info = (json['info'] as List)
        .map((e) => Info.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$ShipModalToJson(ShipModal instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'info': instance.info
    };

ShipOrder _$ShipOrderFromJson(Map<String, dynamic> json) {
  return ShipOrder()
    ..id = json['id'] as int
    ..code = json['code'] as String
    ..modal = json['modal'] as int
    ..operate_at = json['operate_at'] as String
    ..finished = json['finished'] as bool
    ..operator = json['operator'] as int
    ..info = (json['info'] as List)
        .map((e) => Info.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$ShipOrderToJson(ShipOrder instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'modal': instance.modal,
      'operate_at': instance.operate_at,
      'finished': instance.finished,
      'operator': instance.operator,
      'info': instance.info
    };

ShipDetail _$ShipDetailFromJson(Map<String, dynamic> json) {
  return ShipDetail()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..category = json['category'] as int
    ..quantity_plan = json['quantity_plan'] as int
    ..quantity_actual = json['quantity_actual'] as int
    ..ship_instance = json['ship_instance'] as int;
}

Map<String, dynamic> _$ShipDetailToJson(ShipDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'quantity_plan': instance.quantity_plan,
      'quantity_actual': instance.quantity_actual,
      'ship_instance': instance.ship_instance
    };

ShipInfo _$ShipInfoFromJson(Map<String, dynamic> json) {
  return ShipInfo()
    ..id = json['id'] as int
    ..product = json['product'] as int
    ..code = json['code'] as String
    ..product_code = json['product_code'] as String
    ..operate_at = json['operate_at'] as String
    ..ship_detail = json['ship_detail'] as int
    ..operator = json['operator'] as int;
}

Map<String, dynamic> _$ShipInfoToJson(ShipInfo instance) => <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'code': instance.code,
      'product_code': instance.product_code,
      'operate_at': instance.operate_at,
      'ship_detail': instance.ship_detail,
      'operator': instance.operator
    };
