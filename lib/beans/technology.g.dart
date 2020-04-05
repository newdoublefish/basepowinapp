// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'technology.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TechDetail _$TechDetailFromJson(Map<String, dynamic> json) {
  return TechDetail()
    ..name = json['name'] as String
    ..type = json['type'] as String
    ..value = json['value']
    ..reg = json['reg'] as String
    ..choices = (json['choices'] as List)?.map((e) => e as String)?.toList();
}

Map<String, dynamic> _$TechDetailToJson(TechDetail instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'value': instance.value,
      'reg': instance.reg,
      'choices': instance.choices
    };

Tech _$TechFromJson(Map<String, dynamic> json) {
  return Tech()
    ..id = json['id'] as int
    ..code = json['code'] as String
    ..modal = json['modal'] as int
    ..modalname = json['modalname'] as String
    ..flow_text = json['flow_text'] as String
    ..node_text = json['node_text'] as String
    ..username = json['username'] as String
    ..pub_date = json['pub_date'] as String
    ..project_detail = json['project_detail'] as int
    ..finished = json['finished'] as bool
    ..detail = (json['detail'] as List)
        ?.map((e) =>
            e == null ? null : TechDetail.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TechToJson(Tech instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'modal': instance.modal,
      'modalname': instance.modalname,
      'flow_text': instance.flow_text,
      'node_text': instance.node_text,
      'username': instance.username,
      'pub_date': instance.pub_date,
      'project_detail': instance.project_detail,
      'finished': instance.finished,
      'detail': instance.detail
    };

TechDetailGroup _$TechDetailGroupFromJson(Map<String, dynamic> json) {
  return TechDetailGroup()
    ..name = json['name'] as String
    ..items = (json['items'] as List)
        .map((e) => TechDetail.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$TechDetailGroupToJson(TechDetailGroup instance) =>
    <String, dynamic>{'name': instance.name, 'items': instance.items};

TechnologyModal _$TechnologyModalFromJson(Map<String, dynamic> json) {
  return TechnologyModal()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..description = json['description'] as String
    ..detail = (json['detail'] as List)
        ?.map((e) => e == null
            ? null
            : TechDetailGroup.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TechnologyModalToJson(TechnologyModal instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'detail': instance.detail
    };
