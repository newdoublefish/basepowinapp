import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/core/object_filter_page.dart';
import 'package:manufacture/core/object_generate_page.dart';
import 'package:manufacture/data/repository/flow_nodes_repository.dart';
import 'package:manufacture/data/repository/flow_repository.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:manufacture/ui/pages/flow_instance_process_page.dart';
import 'package:manufacture/ui/widget/smart_filter_page/smart_filter_page.dart';
import 'package:flutter/cupertino.dart';
import '../../core/object_manager_page.dart';
import 'package:manufacture/beans/base_bean.dart';

class FlowInstanceManager extends StatefulWidget {
  final Detail detail;
  final UserRepository userRepository;
  final bool canDeleteSingle;
  final bool canDeleteBatch;
  final bool canAddEditObject;
  FlowInstanceManager({@required this.detail, @required this.userRepository,this.canDeleteSingle = true,
    this.canDeleteBatch = true,
    this.canAddEditObject = true}) : assert(detail != null);
  @override
  State<StatefulWidget> createState() => _FlowInstanceManagerState();
}

class _FlowInstanceManagerState extends State<FlowInstanceManager> {
  FlowInstanceObjectRepository _flowInstanceObjectRepository;
  FlowNodeObjectRepository _flowNodeObjectRepository;
  _FlowInstanceGenerateDelegate _flowInstanceGenerateDelegate;
  ObjectManagerController _objectManagerController = ObjectManagerController("refresh");
  @override
  void initState() {
    _flowNodeObjectRepository = FlowNodeObjectRepository.init();
    _flowInstanceObjectRepository = FlowInstanceObjectRepository.init();
    _flowInstanceGenerateDelegate = _FlowInstanceGenerateDelegate(detail: widget.detail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<FlowInstance>(
      title: "流水管理",
      objectManagerController: _objectManagerController,
      initQueryParams: {"product_detail": widget.detail.id},
      objectRepository: _flowInstanceObjectRepository,
      canAddEditObject: widget.canAddEditObject,
      canDeleteSingle: widget.canDeleteSingle,
      canDeleteBatch: widget.canDeleteBatch,
      itemWidgetBuilder: (context, BaseBean obj) {
        Widget widget = ListTile(
          leading: Icon(Icons.airport_shuttle,color: Theme.of(context).accentColor,),
          title: Text((obj as FlowInstance).code),
          trailing: Text((obj as FlowInstance).status),
        );
        return widget;
      },
      filterGroupList: [
        FilterGroup(niceName: "流水状态", filterName: "status", filterItems: [
          FilterItem(
            niceName: "全部",
          ),
          FilterItem(niceName: "未开始", filterValue: "0"),
          FilterItem(niceName: "进行中", filterValue: "1"),
          FilterItem(niceName: "结束", filterValue: "2"),
        ]),
        FilterGroup(
            niceName: "当前节点",
            filterName: "current_node",
            builder: (context, func) {
              return ObjectFilterPage<Node>(
                objectRepository: _flowNodeObjectRepository,
                filterItemChange: func,
                onItemNiceName: (BaseBean result) {
                  return (result as Node).name.toString();
                },
              );
            }),
      ],
      onTap: (BaseBean value) {
        Navigator.push(context, MaterialPageRoute(builder: (context){
        return FlowInstanceProcess(
          instance: value as FlowInstance,
          flowInstanceObjectRepository: _flowInstanceObjectRepository,
        );
        }));
      },
//      addEditPageBuilder: (context, BaseBean obj){
//        return OrganizationAddEditPage(
//          organization: obj as Organization,
//          objectRepository: _organizationObjectRepository,
//        );
//      },
      extraPopupButton: <Widget>[
        PopupMenuItem<void>(
          child: ListTile(
            leading: Icon(Icons.create_new_folder),
            title: Text("流水号批量生成"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push<bool>(context,
                  MaterialPageRoute(builder: (context) {
//                    return TechnologyGenerate(
//                      projectObjectRepository: _projectObjectRepository,
//                      techObjectRepository: _techObjectRepository,
//                    );
                    return ObjectGeneratePage<FlowInstance>(
                      objectRepository: _flowInstanceObjectRepository,
                      objectGenerateDelegate: _flowInstanceGenerateDelegate,
                    );
                  })).then((result) {
                    print("--------------------$result");
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

class _FlowInstanceGenerateDelegate extends ObjectGenerateDelegate<FlowInstance>{
  final Detail detail;
  _FlowInstanceGenerateDelegate({@required this.detail}):assert(detail!=null);


  @override
  bool onVerify(BuildContext context) {
    return true;
  }

  @override
  FlowInstance buildObject(String code) {
    FlowInstance _instance = FlowInstance();
    _instance.code = code;
    _instance.modal = detail.flow;
    _instance.product_detail = detail.id;
    return _instance;
  }

  @override
  String buildTitle() {
    return "流水号批量生成";
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

