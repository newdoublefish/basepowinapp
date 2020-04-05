import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/organization.dart';
import 'package:manufacture/data/repository/unit_repository.dart';
import '../../core/object_manager_page.dart';
import 'unit_add_edit_page.dart';
import 'position_manager_page.dart';


class UnitManager extends StatefulWidget{
  final Organization organization;
  UnitManager({Key key, this.organization}):super(key:key);
  @override
  State<StatefulWidget> createState() => _UnitManagerState();
}

class _UnitManagerState extends State<UnitManager>{
  UnitObjectRepository _unitObjectRepository;
  @override
  void initState() {
    _unitObjectRepository = UnitObjectRepository.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Unit>(
      title: "部门管理",
      initQueryParams: {"organization": widget.organization.id},
      objectRepository:_unitObjectRepository,
      itemWidgetBuilder: (context, BaseBean obj){
        Widget widget = ListTile(
          leading: ExcludeSemantics(
        child: CircleAvatar(child: Text((obj as Unit).name[0]))),
          title: Text((obj as Unit).name),
        );
        return widget;
      },
      onTap: (BaseBean value){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return PositionManager(
            unit: value as Unit,
          );
        }));
      },
      addEditPageBuilder: (context, BaseBean obj){
        return UnitAddEditPage(
          objectRepository: _unitObjectRepository,
          organization: widget.organization,
          unit: obj as Unit,
        );
      },
    );
  }

}