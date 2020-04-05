import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/organization.dart';
import 'package:manufacture/data/repository/position_repository.dart';
import '../../core/object_manager_page.dart';
import 'position_add_edit_page.dart';


class PositionManager extends StatefulWidget{
  final Unit unit;
  PositionManager({Key key, this.unit}):super(key:key);
  @override
  State<StatefulWidget> createState() => _PositionManagerState();
}

class _PositionManagerState extends State<PositionManager>{
  PositionObjectRepository _objectRepository;
  @override
  void initState() {
    _objectRepository = PositionObjectRepository.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Position>(
      title: "岗位管理",
      initQueryParams: {"unit": widget.unit.id},
      objectRepository:_objectRepository,
      itemWidgetBuilder: (context, BaseBean obj){
        Widget widget = ListTile(
          leading: ExcludeSemantics(
              child: CircleAvatar(child: Text((obj as Position).name[0]))),
          title: Text((obj as Position).name),
        );
        return widget;
      },
      onTap: (BaseBean value){
        print(value as Position);
      },
      addEditPageBuilder: (context, BaseBean obj){
        return PositionAddEditPage(
          objectRepository: _objectRepository,
          position: obj as Position,
          unit: widget.unit,
        );
      },
    );
  }

}