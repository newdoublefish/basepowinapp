import 'package:json_annotation/json_annotation.dart';
import 'base_bean.dart';
part 'mop.g.dart';

@JsonSerializable(nullable: false)
class Mop extends BaseBean{
  String sell_order_name;
  int sell_order;
  String manufacture_order_name;
  String manufacture_order;
  String part_no_name;
  String part_no;
  int quantity;
  int status;
  String status_name;
  String created_at;
  String updated_at;
  Mop();
  factory Mop.fromJson(Map<String, dynamic> json) => _$MopFromJson(json);
  Map<String, dynamic> toJson() => _$MopToJson(this);
}