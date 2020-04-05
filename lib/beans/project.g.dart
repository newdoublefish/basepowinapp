// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlowHistory _$FlowHistoryFromJson(Map<String, dynamic> json) {
  return FlowHistory()
    ..id = json['id'] as int
    ..instance = json['instance'] as int
    ..node = json['node'] as int
    ..work_type = json['work_type'] as int
    ..work_pk = json['work_pk'] as int
    ..check_at = json['check_at'] as String
    ..check_by = json['check_by'] as String
    ..status = json['status'] as String;
}

Map<String, dynamic> _$FlowHistoryToJson(FlowHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'instance': instance.instance,
      'node': instance.node,
      'work_type': instance.work_type,
      'work_pk': instance.work_pk,
      'check_at': instance.check_at,
      'check_by': instance.check_by,
      'status': instance.status
    };

Project _$ProjectFromJson(Map<String, dynamic> json) {
  return Project()
    ..id = json['id'] as int
    ..code = json['code'] as String
    ..name = json['name'] as String
    ..start = json['start'] as String
    ..end = json['end'] as String
    ..status = json['status'] as int;
}

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'start': instance.start,
      'end': instance.end,
      'status': instance.status
    };

Node _$NodeFromJson(Map<String, dynamic> json) {
  return Node()
    ..id = json['id'] as int
    ..code = json['code'] as String
    ..name = json['name'] as String
    ..node_type = json['node_type'] as int
    ..type_id = json['type_id'] as int
    ..need_check = json['need_check'] as bool
    ..is_work_share = json['is_work_share'] as bool
    ..is_first = json['is_first'] as bool
    ..is_end = json['is_end'] as bool
    ..out_flow = json['out_flow'] as bool
    ..can_skip = json['can_skip'] as bool
    ..modal = json['modal'] as int
    ..next = json['next'] as int;
}

Map<String, dynamic> _$NodeToJson(Node instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'node_type': instance.node_type,
      'type_id': instance.type_id,
      'need_check': instance.need_check,
      'is_work_share': instance.is_work_share,
      'is_first': instance.is_first,
      'is_end': instance.is_end,
      'out_flow': instance.out_flow,
      'can_skip': instance.can_skip,
      'modal': instance.modal,
      'next': instance.next
    };

Procedure _$ProcedureFromJson(Map<String, dynamic> json) {
  return Procedure()
    ..id = json['id'] as int
    ..code = json['code'] as String
    ..name = json['name'] as String
    ..description = json['description'] as String;
}

Map<String, dynamic> _$ProcedureToJson(Procedure instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'description': instance.description
    };

Trade _$TradeFromJson(Map<String, dynamic> json) {
  return Trade()
    ..id = json['id'] as int
    ..code = json['code'] as String
    ..name = json['name'] as String
    ..trade = json['trade'] as int;
}

Map<String, dynamic> _$TradeToJson(Trade instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'trade': instance.trade
    };

Brand _$BrandFromJson(Map<String, dynamic> json) {
  return Brand()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..pinyin = json['pinyin'] as String;
}

Map<String, dynamic> _$BrandToJson(Brand instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pinyin': instance.pinyin
    };

Category _$CategoryFromJson(Map<String, dynamic> json) {
  return Category()
    ..id = json['id'] as int
    ..code = json['code'] as String
    ..name = json['name'] as String
    ..trade = json['trade'] as int;
}

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'trade': instance.trade
    };

Detail _$DetailFromJson(Map<String, dynamic> json) {
  return Detail()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..count = json['count'] as int
    ..project = json['project'] as int
    ..project_name = json['project_name'] as String
    ..odm = json['odm'] as int
    ..odm_name = json['odm_name'] as String
    ..remark = json['remark'] as String
    ..flow = json['flow'] as int;
}

Map<String, dynamic> _$DetailToJson(Detail instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'count': instance.count,
      'project': instance.project,
      'project_name': instance.project_name,
      'odm': instance.odm,
      'odm_name': instance.odm_name,
      'remark': instance.remark,
      'flow': instance.flow
    };

FlowInstance _$FlowInstanceFromJson(Map<String, dynamic> json) {
  return FlowInstance()
    ..id = json['id'] as int
    ..code = json['code'] as String
    ..product_code = json['product_code'] as String
    ..current_node = json['current_node'] as int
    ..modal = json['modal'] as int
    ..status = json['status'] as String
    ..product_detail = json['product_detail'] as int;
}

Map<String, dynamic> _$FlowInstanceToJson(FlowInstance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'product_code': instance.product_code,
      'current_node': instance.current_node,
      'modal': instance.modal,
      'status': instance.status,
      'product_detail': instance.product_detail
    };

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product()
    ..id = json['id'] as int
    ..code = json['code'] as String
    ..category = json['category'] as int
    ..category_text = json['category_text'] as String
    ..status = json['status'] as int
    ..status_text = json['status_text'] as String
    ..brand = json['brand'] as int
    ..brand_text = json['brand_text'] as String
    ..project = json['project'] as int
    ..project_text = json['project_text'] as String
    ..product_at = json['product_at'] as String;
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'category': instance.category,
      'category_text': instance.category_text,
      'status': instance.status,
      'status_text': instance.status_text,
      'brand': instance.brand,
      'brand_text': instance.brand_text,
      'project': instance.project,
      'project_text': instance.project_text,
      'product_at': instance.product_at
    };

ProductAttribute _$ProductAttributeFromJson(Map<String, dynamic> json) {
  return ProductAttribute()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..data_type = json['data_type'] as int
    ..value = json['value'] as String
    ..category = json['category'] as int;
}

Map<String, dynamic> _$ProductAttributeToJson(ProductAttribute instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'data_type': instance.data_type,
      'value': instance.value,
      'category': instance.category
    };
