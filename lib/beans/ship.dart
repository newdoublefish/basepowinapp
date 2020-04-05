import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_bean.dart';
import 'project.dart';
part 'ship.g.dart';

@JsonSerializable(nullable: false)
class Info{
  String name;
  dynamic value;

  Info();

  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
  Map<String, dynamic> toJson() => _$InfoToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "Info {name:$name, value:$value}";
  }
}

@JsonSerializable(nullable: false)
class ShipModal extends BaseBean{
  String name;
  List<Info> info;

  ShipModal();
  factory ShipModal.fromJson(Map<String, dynamic> json) => _$ShipModalFromJson(json);
  Map<String, dynamic> toJson() => _$ShipModalToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "ShipModal {id:$id, name:$name, info:$info}";
  }


}

@JsonSerializable(nullable: false)
class ShipOrder extends BaseBean{
  String code;
  int modal;
  String operate_at;
  bool finished;
  int operator;
  List<Info> info;

  ShipOrder();

  factory ShipOrder.fromJson(Map<String, dynamic> json) => _$ShipOrderFromJson(json);
  Map<String, dynamic> toJson() => _$ShipOrderToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "ShipOrder {id:$id, code:$code, operate_at:$operate_at, finished:$finished, operator:$operator, info:$info,modal:$modal}";
  }
}


@JsonSerializable(nullable: false)
class ShipDetail extends BaseBean{
  String name;
  int category;
  int quantity_plan;
  int quantity_actual;
  int ship_instance;

  ShipDetail();

  factory ShipDetail.fromJson(Map<String, dynamic> json) => _$ShipDetailFromJson(json);
  Map<String, dynamic> toJson() => _$ShipDetailToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "ShipOrder {id:$id, name:$name, category:$category, quantity_plan:$quantity_plan, quantity_actual:$quantity_actual, ship_instance:$ship_instance,}";
  }
}

@JsonSerializable(nullable: false)
class ShipInfo extends BaseBean{
  int product;
  String code;
  String product_code;
  String operate_at;
  int ship_detail;
  int operator;

  ShipInfo();

  factory ShipInfo.fromJson(Map<String, dynamic> json) => _$ShipInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ShipInfoToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "ShipInfo {id:$id,product:$product,code:$code,operate_at:$operate_at,ship_detail:$ship_detail,operator:$operator}";
  }
}