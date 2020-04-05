// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressDetail _$ProgressDetailFromJson(Map<String, dynamic> json) {
  return ProgressDetail(
      name: json['name'] as String, count: json['count'] as int);
}

Map<String, dynamic> _$ProgressDetailToJson(ProgressDetail instance) =>
    <String, dynamic>{'name': instance.name, 'count': instance.count};

Progress _$ProgressFromJson(Map<String, dynamic> json) {
  return Progress()
    ..total = json['total'] as int
    ..finished = json['finished'] as int
    ..delivered = json['delivered'] as int
    ..detail = (json['detail'] as List)
        .map((e) => ProgressDetail.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$ProgressToJson(Progress instance) => <String, dynamic>{
      'total': instance.total,
      'finished': instance.finished,
      'delivered': instance.delivered,
      'detail': instance.detail
    };
