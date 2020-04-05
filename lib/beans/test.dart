import 'package:json_annotation/json_annotation.dart';
import 'base_bean.dart';
part 'test.g.dart';

@JsonSerializable(nullable: false)
class TestItem{
  int id;
  String name;
  String start;
  String end;
  String value;
  String pass;
  int error;
  int total;
  TestItem();

  factory TestItem.fromJson(Map<String,dynamic> json) => _$TestItemFromJson(json);
  Map<String,dynamic> toJson() => _$TestItemToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "TestItem:{$id, $name, $start, $end, $value, $pass, $error, $total}";
  }
}

@JsonSerializable(nullable: false)
class TestGroup{
  String name;
  List<TestItem> items;
  TestGroup();

  factory TestGroup.fromJson(Map<String,dynamic> json) => _$TestGroupFromJson(json);
  Map<String,dynamic> toJson() => _$TestGroupToJson(this);
}

@JsonSerializable(nullable: false)
class TestDetail{
  List<TestGroup> results;
  TestDetail();
  factory TestDetail.fromJson(Map<String,dynamic> json) => _$TestDetailFromJson(json);
  Map<String,dynamic> toJson() => _$TestDetailToJson(this);
}

@JsonSerializable(nullable: false)
class Test extends BaseBean{
  String code;
  int test_type;
  int result_integer;
  @JsonKey(nullable: true)
  TestDetail detail;
  String test_name;
  String username;
  String pub_date;
  @JsonKey(nullable: true)
  String project_file;

  Test();

  factory Test.fromJson(Map<String,dynamic> json) => _$TestFromJson(json);
  Map<String,dynamic> toJson() => _$TestToJson(this);
}