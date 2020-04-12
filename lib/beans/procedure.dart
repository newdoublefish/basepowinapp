import 'package:json_annotation/json_annotation.dart';
import 'base_bean.dart';
part 'procedure.g.dart';

@JsonSerializable(nullable: false)
class Procedure extends BaseBean{
  String name;
  int mop;
  String mop_name;
  String part_no_name;
  int parent;
  int dept;
  String dept_name;
  int quantity;
  int received_quantity;
  int delivered_quantity;
  int remake_quantity;
  int status;
  int status_name;
  String created_at;
  String updated_at;
  Procedure();

  factory Procedure.fromJson(Map<String, dynamic> json) => _$ProcedureFromJson(json);
  Map<String, dynamic> toJson() => _$ProcedureToJson(this);
}