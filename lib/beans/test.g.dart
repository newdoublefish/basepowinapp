// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TestItem _$TestItemFromJson(Map<String, dynamic> json) {
  return TestItem()
    ..id = json['id'] as int
    ..name = json['name'] as String
    ..start = json['start'] as String
    ..end = json['end'] as String
    ..value = json['value'] as String
    ..pass = json['pass'] as String
    ..error = json['error'] as int
    ..total = json['total'] as int;
}

Map<String, dynamic> _$TestItemToJson(TestItem instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'start': instance.start,
      'end': instance.end,
      'value': instance.value,
      'pass': instance.pass,
      'error': instance.error,
      'total': instance.total
    };

TestGroup _$TestGroupFromJson(Map<String, dynamic> json) {
  return TestGroup()
    ..name = json['name'] as String
    ..items = (json['items'] as List)
        .map((e) => TestItem.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$TestGroupToJson(TestGroup instance) =>
    <String, dynamic>{'name': instance.name, 'items': instance.items};

TestDetail _$TestDetailFromJson(Map<String, dynamic> json) {
  return TestDetail()
    ..results = (json['results'] as List)
        .map((e) => TestGroup.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$TestDetailToJson(TestDetail instance) =>
    <String, dynamic>{'results': instance.results};

Test _$TestFromJson(Map<String, dynamic> json) {
  return Test()
    ..id = json['id'] as int
    ..code = json['code'] as String
    ..test_type = json['test_type'] as int
    ..result_integer = json['result_integer'] as int
    ..detail = json['detail'] == null
        ? null
        : TestDetail.fromJson(json['detail'] as Map<String, dynamic>)
    ..test_name = json['test_name'] as String
    ..username = json['username'] as String
    ..pub_date = json['pub_date'] as String
    ..project_file = json['project_file'] as String;
}

Map<String, dynamic> _$TestToJson(Test instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'test_type': instance.test_type,
      'result_integer': instance.result_integer,
      'detail': instance.detail,
      'test_name': instance.test_name,
      'username': instance.username,
      'pub_date': instance.pub_date,
      'project_file': instance.project_file
    };
