import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
part 'progress.g.dart';

@JsonSerializable(nullable: false)
class ProgressDetail{
  String name;
  int count;


  ProgressDetail({this.name,this.count});

  factory ProgressDetail.fromJson(Map<String, dynamic> json) => _$ProgressDetailFromJson(json);
  Map<String, dynamic> toJson() => _$ProgressDetailToJson(this);
}

@JsonSerializable(nullable: false)
class Progress{
  int total;
  int finished;
  int delivered;
  List<ProgressDetail> detail;

  Progress();

  factory Progress.fromJson(Map<String, dynamic> json) => _$ProgressFromJson(json);
  Map<String, dynamic> toJson() => _$ProgressToJson(this);
}