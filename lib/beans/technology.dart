import 'package:json_annotation/json_annotation.dart';

import 'base_bean.dart';
part 'technology.g.dart';
@JsonSerializable(nullable: false)
class TechDetail{
  String name;
  @JsonKey(nullable: true)
  String type;
  @JsonKey(nullable: true)
  dynamic value;
  @JsonKey(nullable: true)
  String reg;
  @JsonKey(nullable: true)
  List<String> choices;

  TechDetail();

  factory TechDetail.fromJson(Map<String,dynamic> json) => _$TechDetailFromJson(json);
  Map<String,dynamic> toJson() => _$TechDetailToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "TechDetail {name:$name,type:$type,value:$value,}";
  }
}

@JsonSerializable(nullable: false)
class Tech extends BaseBean{
  String code;
  int modal;
  String modalname;
  String flow_text;
  String node_text;
  String username;
  String pub_date;
  int project_detail;
  bool finished;
  @JsonKey(nullable: true)
  List<TechDetail> detail;

  Tech();

  factory Tech.fromJson(Map<String,dynamic> json) => _$TechFromJson(json);
  Map<String,dynamic> toJson() => _$TechToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "Tech {code:$code, modal:$modal, flow_text:$flow_text,node_text:$node_text,detail:$detail,username:$username, pub_date:$pub_date, finshed:$finished}";
  }
}

@JsonSerializable(nullable: false)
class TechDetailGroup{
  String name;
  List<TechDetail> items;

  TechDetailGroup();

  factory TechDetailGroup.fromJson(Map<String,dynamic> json) => _$TechDetailGroupFromJson(json);
  Map<String,dynamic> toJson() => _$TechDetailGroupToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "TechDetailGroup {name:$name,items:$items,}";
  }
}

@JsonSerializable(nullable: false)
class TechnologyModal extends BaseBean{
  String name;
  String description;
  @JsonKey(nullable: true)
  List<TechDetailGroup> detail;
  TechnologyModal();
  factory TechnologyModal.fromJson(Map<String,dynamic> json) => _$TechnologyModalFromJson(json);
  Map<String,dynamic> toJson() => _$TechnologyModalToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "TechnologyModal {id:$id, name:$name,count:$description,detail:$detail,}";
  }
}
