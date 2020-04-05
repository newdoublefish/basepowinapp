import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/flow_modals_repository.dart';
import 'package:manufacture/ui/pages/flow_modal_add_edit_page.dart';
import '../../core/object_manager_page.dart';
import 'flow_modal_procedure.dart';


class FlowModeManager extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _FlowModeManagerState();
}

class _FlowModeManagerState extends State<FlowModeManager>{
  FlowModalsObjectRepository _flowModalsObjectRepository;
  @override
  void initState() {
    _flowModalsObjectRepository = FlowModalsObjectRepository.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Procedure>(
      title: "流程管理",
      //initQueryParams: {"product_detail": 14},
      objectRepository:_flowModalsObjectRepository,
      itemWidgetBuilder: (context, BaseBean obj){
        Widget widget = ListTile(
          leading: ExcludeSemantics(
              child: CircleAvatar(child: Text((obj as Procedure).name[0]))),
          title: Text((obj as Procedure).name),
          subtitle: Text((obj as Procedure).code),
        );
        return widget;
      },
      onTap: (BaseBean value){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return FlowModalProcedure(procedure: value as Procedure,);
        }));
      },
      addEditPageBuilder: (context, BaseBean obj){
        return FlowModalAddEditPage(
          object: obj as Procedure,
          objectRepository: _flowModalsObjectRepository,
        );
      },
    );
  }
}