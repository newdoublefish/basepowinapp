import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/technology.dart';
import 'package:manufacture/core/object_generate_page.dart';
import 'package:manufacture/core/object_filter_page.dart';
//import 'package:manufacture/core/object_select_dialog.dart';
//import 'package:manufacture/core/object_selector.dart';
import '../../core/object_select_dialog.dart';
import '../../core/object_selector.dart';
import 'package:manufacture/data/repository/detail_repository.dart';
import 'package:manufacture/data/repository/project_respository.dart';
import 'package:manufacture/ui/pages/tech_report_page.dart';
import 'package:manufacture/ui/widget/smart_filter_page/smart_filter_page.dart';
import 'package:manufacture/util/dialog_util.dart';
import '../../core/object_manager_page.dart';
import 'package:manufacture/data/repository/tech_repository.dart';

import '../../core/object_select_widget.dart';

class TechManagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TechManagePageState();
}

class _TechManagePageState extends State<TechManagePage> {
  TechObjectRepository _techObjectRepository;
  TechnologyModalRepository _technologyModalRepository;
  ProjectObjectRepository _projectObjectRepository;
  ObjectManagerController _objectManagerController = ObjectManagerController("refresh");
  _TechDelegate __techDelegate = _TechDelegate();
  @override
  void initState() {
    _techObjectRepository = TechObjectRepository.init();
    _technologyModalRepository = TechnologyModalRepository.init();
    _projectObjectRepository = ProjectObjectRepository.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Tech>(
      title: "二维码信息管理",
      //initQueryParams: {"organization": widget.organization.id},
      objectManagerController: _objectManagerController,
      filterGroupList: [
        FilterGroup(
            niceName: "类型",
            filterName: "modal",
            builder: (context, func) {
              return ObjectFilterPage<TechnologyModal>(
                objectRepository: _technologyModalRepository,
                filterItemChange: func,
                onItemNiceName: (BaseBean result) {
                  return (result as TechnologyModal).name;
                },
              );
            }),
        FilterGroup(
            niceName: "项目",
            filterName: "project_detail_project",
            builder: (context, func) {
              return ObjectFilterPage<Project>(
                objectRepository: _projectObjectRepository,
                filterItemChange: func,
                onItemNiceName: (BaseBean result) {
                  return (result as Project).code;
                },
              );
            }),
          FilterGroup(niceName: "完成情况", filterName: "finished", filterItems: [
            FilterItem(
              niceName: "全部",
            ),
            FilterItem(niceName: "未完成", filterValue: "false"),
            FilterItem(niceName: "已完成", filterValue: "true"),
          ]),
      ],
      objectRepository: _techObjectRepository,
      itemWidgetBuilder: (context, BaseBean obj) {
        Widget widget = ListTile(
          leading: ExcludeSemantics(
              child: CircleAvatar(child: Text((obj as Tech).code[0]))),
          title: Text((obj as Tech).code),
        );
        return widget;
      },
      onTap: (BaseBean value) {
//        Navigator.push(context, MaterialPageRoute(builder: (context){
//          return CategoryManage(
//            trade: value as Trade,
//          );
//        }));
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return TechReportPage(
            techId: value.id,
            node: null,
          );
        }));
      },
//      addEditPageBuilder: (context, BaseBean obj){
//        return TradeAddEditPage(
//          objectRepository: _tradeObjectRepository,
//          trade: obj as Trade,
//        );
//      },
      extraPopupButton: <Widget>[
        PopupMenuItem<void>(
          child: ListTile(
            leading: Icon(Icons.create_new_folder),
            title: Text("二维码批量注册"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<bool>(context,
                  MaterialPageRoute(builder: (context) {
//                    return TechnologyGenerate(
//                      projectObjectRepository: _projectObjectRepository,
//                      techObjectRepository: _techObjectRepository,
//                    );
                      return ObjectGeneratePage<Tech>(
                        objectRepository: _techObjectRepository,
                        objectGenerateDelegate: __techDelegate,
                      );
                  })).then((result) {
                if (result != null) {
                  //TODO: to refresh
                  _objectManagerController.requestRefresh();
                }
              });
            },
          ),
        ),
      ],
    );
  }
}

class _TechDelegate extends ObjectGenerateDelegate<Tech>{
//  ProjectObjectRepository _projectObjectRepository = ProjectObjectRepository.init();
//  ObjectSelectController<Project> _projectObjectSelectController = new ObjectSelectController<Project>();
  DetailObjectRepository _detailObjectRepository = DetailObjectRepository.init();
  ProjectObjectRepository _projectObjectRepository = ProjectObjectRepository.init();
  ObjectSelectController _objectSelectController = new ObjectSelectController<Detail>();
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text("批次"),
      dense: true,
      title: ObjectSelector<Detail>(
        objectRepository: _detailObjectRepository,
        title: "任务选择",
        buildValueText: (BaseBean detail) {
          return (detail as Detail).name;
        },
        //object: Detail()..id = 1,
        controller: _objectSelectController,
        objectSelectDialog: ObjectSelectDialog(tobeSelectList: [
          ObjectTobeSelect<Project>(
              title: "项目",
              buildQueryParam: (BaseBean t) {
                return null;
              },
              objectRepository: _projectObjectRepository,
              buildObjectItem: (BaseBean t) {
                return Text(((t as Project).code));
              }),
          ObjectTobeSelect<Detail>(
              title: "任务",
              buildQueryParam: (BaseBean t) {
                return {"project":t.id};
              },
              objectRepository: _detailObjectRepository,
              buildObjectItem: (BaseBean t) {
                return Text(((t as Detail).name));
              }),
        ]),
      ),
    );
  }

  @override
  bool onVerify(BuildContext context) {
    if(_objectSelectController.selectObject ==null){
      DialogUtil.alert(context, content: Text("请选择批次号"));
      return false;
    }
    return true;
  }

  @override
  Tech buildObject(String code) {
    Tech tech = Tech();
    tech.code = code;
    tech.finished=false;
    if(_objectSelectController.selectObject!=null)
      tech.project_detail = _objectSelectController.selectObject.id;
    return tech;
  }

  @override
  String buildTitle() {
    return "二维码批量注册";
  }
}

