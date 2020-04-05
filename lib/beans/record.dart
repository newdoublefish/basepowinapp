import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_bean.dart';
part 'record.g.dart';

@JsonSerializable(nullable: false)
class RecordType extends BaseBean{
  String code;
  String name;
  String description;

  RecordType();

  factory RecordType.fromJson(Map<String, dynamic> json) => _$RecordTypeFromJson(json);
  Map<String, dynamic> toJson() => _$RecordTypeToJson(this);

}