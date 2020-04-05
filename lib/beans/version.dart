import 'package:json_annotation/json_annotation.dart';
part 'version.g.dart';

@JsonSerializable(nullable: false)
class Version{
  String version;
  String app_url;
  bool is_valid;
  int terminal_type;
  String release_note;

  Version();

  factory Version.fromJson(Map<String,dynamic> json) => _$VersionFromJson(json);
  Map<String,dynamic> toJson() => _$VersionToJson(this);

  @override
  String toString() {
    // TODO: implement toString
    return "{version:$version, app_url:$app_url, is_valid:$is_valid, terminal_type:$terminal_type, release_note:$release_note}";
  }
}