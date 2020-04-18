import 'package:json_annotation/json_annotation.dart';
import 'package:manufacture/beans/base_bean.dart';
part 'task.g.dart';

@JsonSerializable(nullable: false)
class Task extends BaseBean{
  String name;
  String sub_procedure;
  int procedure;
  String procedure_name;
  int plan_quantity;
  int quantity;
  double weight;
  String created_at;
  String started_at;
  String stopped_at;
  String username;
  String status_text;
  Task();

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}