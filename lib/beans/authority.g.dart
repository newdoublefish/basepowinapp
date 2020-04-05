// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authority.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Authority _$AuthorityFromJson(Map<String, dynamic> json) {
  return Authority(
      can_operate: json['can_operate'] as bool,
      can_reset_total: json['can_reset_total'] as bool,
      can_reset_single: json['can_reset_single'] as bool,
      can_skip: json['can_skip'] as bool,
      can_view: json['can_view'] as bool)
    ..id = json['id'] as int
    ..user = json['user'] as int;
}

Map<String, dynamic> _$AuthorityToJson(Authority instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'can_operate': instance.can_operate,
      'can_reset_total': instance.can_reset_total,
      'can_reset_single': instance.can_reset_single,
      'can_skip': instance.can_skip,
      'can_view': instance.can_view
    };
