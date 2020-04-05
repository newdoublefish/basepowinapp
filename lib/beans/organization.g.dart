// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Position _$PositionFromJson(Map<String, dynamic> json) {
  return Position()
    ..id = json['id'] as int
    ..unit = json['unit'] as int
    ..name = json['name'] as String
    ..short = json['short'] as String
    ..pinyin = json['pinyin'] as String;
}

Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
      'id': instance.id,
      'unit': instance.unit,
      'name': instance.name,
      'short': instance.short,
      'pinyin': instance.pinyin
    };

Unit _$UnitFromJson(Map<String, dynamic> json) {
  return Unit()
    ..id = json['id'] as int
    ..organization = json['organization'] as int
    ..code = json['code'] as String
    ..name = json['name'] as String
    ..short = json['short'] as String
    ..pinyin = json['pinyin'] as String;
}

Map<String, dynamic> _$UnitToJson(Unit instance) => <String, dynamic>{
      'id': instance.id,
      'organization': instance.organization,
      'code': instance.code,
      'name': instance.name,
      'short': instance.short,
      'pinyin': instance.pinyin
    };

Organization _$OrganizationFromJson(Map<String, dynamic> json) {
  return Organization()
    ..id = json['id'] as int
    ..code = json['code'] as String
    ..name = json['name'] as String
    ..short = json['short'] as String
    ..pinyin = json['pinyin'] as String
    ..status = json['status'] as bool
    ..address = json['address'] as String
    ..contacts = json['contacts'] as String
    ..phone = json['phone'] as String
    ..website = json['website'] as String
    ..email = json['email'] as String;
}

Map<String, dynamic> _$OrganizationToJson(Organization instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'short': instance.short,
      'pinyin': instance.pinyin,
      'status': instance.status,
      'address': instance.address,
      'contacts': instance.contacts,
      'phone': instance.phone,
      'website': instance.website,
      'email': instance.email
    };
