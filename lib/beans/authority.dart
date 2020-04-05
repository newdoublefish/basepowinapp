import 'package:json_annotation/json_annotation.dart';
import 'base_bean.dart';
part 'authority.g.dart';

@JsonSerializable(nullable: false)
class Authority extends BaseBean{
  int user;
  bool can_operate;
  bool can_reset_total;
  bool can_reset_single;
  bool can_skip;
  bool can_view;

  Authority({this.can_operate=false, this.can_reset_total=false, this.can_reset_single=false, this.can_skip=false, this.can_view=false});

  factory Authority.fromJson(Map<String, dynamic> json) => _$AuthorityFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorityToJson(this);

  @override
  String toString() {
    return "Authority { can_operate:$can_operate, can_reset_total:$can_reset_total, can_reset_single:$can_reset_single, can_skip:$can_skip, can_view:$can_view}";
  }
}
