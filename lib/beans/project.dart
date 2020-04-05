import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'base_bean.dart';
part 'project.g.dart';
@JsonSerializable(nullable: false)
class FlowHistory extends BaseBean{
  int instance;
  int node;
  int work_type;
  int work_pk;
  String check_at;
  String check_by;
  String status;

  FlowHistory();

  factory FlowHistory.fromJson(Map<String, dynamic> json) => _$FlowHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$FlowHistoryToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "project {id:$id, instance:$instance,node: $node, work_type:$work_type, work_pk:$work_pk, check_at:$check_at, status:$status, check_by:$check_by}";
  }

  String getFormatTime()
  {
      if(this.check_at == null)
        return null;
      var time = DateTime.parse(this.check_at).add(Duration(hours: 8));
      var formatter = new DateFormat('yyy-MM-dd HH:MM:ss');
      return formatter.format(time);
  }

}

@JsonSerializable(nullable: false)
class Project extends BaseBean{
  String code;
  String name;
  String start;
  String end;
  int status;

  static final List<String> statusList=["未开始", "进行中", "已结束"];

  static String getStatus(int status){
    if(status > statusList.length-1 && status < 0){
      return "未定义";
    }
    return statusList[status];
  }

  Project();

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "project {id:$id, code:$code,name: $name, start:$start, status:$status,}";
  }
}

@JsonSerializable(nullable: false)
class Node extends BaseBean{
  String code;
  String name;
  int node_type;
  int type_id;
  bool need_check;
  bool is_work_share;
  bool is_first;
  bool is_end;
  bool out_flow;
  bool can_skip;
  int modal;
  int next;
  Node();

  factory Node.fromJson(Map<String,dynamic> json) => _$NodeFromJson(json);

  Map<String,dynamic> toJson()=> _$NodeToJson(this);
  @override
  String toString() {
    // TODO: implement toString
    return "Node {id:$id, code:$code, name:$name,node_type:$node_type,type_id:$type_id,need_check:$need_check,is_first:$is_first,is_end:$is_end,modal:$modal,next:$next,out_flow:$out_flow,can_skip:$can_skip}";
  }
}

@JsonSerializable(nullable: false)
class Procedure extends BaseBean{
  String code;
  String name;
  String description;
//  @JsonKey(nullable: true)
//  List<Node> nodes;
  Procedure();
  factory Procedure.fromJson(Map<String,dynamic> json) => _$ProcedureFromJson(json);
  Map<String,dynamic> toJson() => _$ProcedureToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "Procedure {id:$id, code:$code,name:$name,description:$description}";
  }
}


@JsonSerializable(nullable: false)
class Trade extends BaseBean{
  String code;
  String name;
  int trade;

  Trade();

  factory Trade.fromJson(Map<String,dynamic> json) => _$TradeFromJson(json);
  Map <String,dynamic> toJson() => _$TradeToJson(this);
}

@JsonSerializable(nullable: false)
class Brand extends BaseBean{
  String name;
  String pinyin;

  Brand();

  factory Brand.fromJson(Map<String,dynamic> json) => _$BrandFromJson(json);
  Map <String,dynamic> toJson() => _$BrandToJson(this);
}



@JsonSerializable(nullable: false)
class Category extends BaseBean{
  String code;
  String name;
  int trade;

  Category();

  factory Category.fromJson(Map<String,dynamic> json) => _$CategoryFromJson(json);
  Map <String,dynamic> toJson() => _$CategoryToJson(this);

}

@JsonSerializable(nullable: true)
class Detail extends BaseBean{
  String name;
  int count;
  int project;
  String project_name;
  int odm;
  String odm_name;
  String remark;
  @JsonKey(nullable: true)
  int flow;

  Detail();

  factory Detail.fromJson(Map<String ,dynamic> json) => _$DetailFromJson(json);
  Map<String ,dynamic> toJson() => _$DetailToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "Detail {id:$id, name:$name,count:$count,project:$project,odm:$odm, odm_name:$odm_name, remark:$remark}";
  }
}

@JsonSerializable(nullable: true)
class FlowInstance extends BaseBean{
  String code;
  String product_code;
  int current_node;
  int modal;
  String status;
  int product_detail;

  FlowInstance();

  factory FlowInstance.fromJson(Map<String, dynamic> json) => _$FlowInstanceFromJson(json);
  Map<String, dynamic> toJson() => _$FlowInstanceToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "FlowInstance {id:$id, code:$code, current_node:$current_node, modal:$modal, status:$status, product_detail：$product_detail}";
  }
}

@JsonSerializable(nullable: true)
class Product extends BaseBean{
  String code;
  int category;
  String category_text;
  int status;
  String status_text;
  int brand;
  String brand_text;
  int project;
  String project_text;
  String product_at;

  Product();

  factory Product.fromJson(Map<String ,dynamic> json) => _$ProductFromJson(json);
  Map<String ,dynamic> toJson() => _$ProductToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "Product {id:$id, code:$code,category:$category,status:$status, product_at:$product_at, brand:$brand}";
  }
}

@JsonSerializable(nullable: true)
class ProductAttribute extends BaseBean{
  String name;
  int data_type;
  String value;
  int category;

  static final List<String> dataTypeList=["字符型", "整型", "浮点型"];

  static String getDataTypeName(int status){
    if(status > dataTypeList.length-1 && status < 0){
      return "未定义";
    }
    return dataTypeList[status];
  }

  ProductAttribute();

  factory ProductAttribute.fromJson(Map<String ,dynamic> json) => _$ProductAttributeFromJson(json);
  Map<String ,dynamic> toJson() => _$ProductAttributeToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "ProductAttribute{name:$name, value:${value.toString()}";
  }
}