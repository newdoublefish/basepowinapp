import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/organization.dart';
import 'package:manufacture/beans/manager.dart';
import 'package:manufacture/beans/user_bean.dart';
import 'package:manufacture/core/object_create_modify_page.dart';
import 'package:manufacture/data/repository/manager_repository.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import '../../core/object_manager_page.dart';
import '../../core/object_select_dialog.dart';
import '../../core/object_selector.dart';
import 'unit_add_edit_page.dart';
import 'position_manager_page.dart';

class ManagerPage extends StatefulWidget {
  final Organization organization;
  ManagerPage({Key key, this.organization}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ManagerState();
}

class _ManagerState extends State<ManagerPage> {
  ManagerObjectRepository _objectRepository;
  @override
  void initState() {
    _objectRepository = ManagerObjectRepository.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Manager>(
      title: "管理员",
      initQueryParams: {"organization": widget.organization.id},
      objectRepository: _objectRepository,
      itemWidgetBuilder: (context, BaseBean obj) {
        Widget widget = ListTile(
          leading: ExcludeSemantics(
              child: CircleAvatar(child: Text((obj as Manager).username[0]))),
          title: Text((obj as Manager).username),
        );
        return widget;
      },
      onTap: (BaseBean value) {
//        Navigator.push(context, MaterialPageRoute(builder: (context){
//          return PositionManager(
//            unit: value as Unit,
//          );
//        }));
      },
      addEditPageBuilder: (context, BaseBean obj){
        return _ManagerAddModify(
          manager: obj as Manager,
          organization: widget.organization,
          managerObjectRepository: _objectRepository,
        );
      },
    );
  }
}

class _ManagerAddModify extends StatefulWidget {
  final Manager manager;
  final ManagerObjectRepository managerObjectRepository;
  final Organization organization;
  _ManagerAddModify({Key key, this.manager, this.managerObjectRepository,this.organization})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ManagerAddModifyState();
}

class _ManagerAddModifyState extends State<_ManagerAddModify> {
  int userId;
  UserObjectRepository _userObjectRepository;
  Manager manager;

  @override
  void initState() {
    if(widget.manager!=null){
      manager = widget.manager;
    }else{
      manager = Manager();
      manager.organization = widget.organization.id;
    }
    _userObjectRepository = UserObjectRepository.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectCreateModifyPage<Manager>(
      title: "管理员",
      type: widget.manager!=null?ObjectOperateType.MODIFY:ObjectOperateType.CREATE,
      objectRepository: widget.managerObjectRepository,
      buildBody: (context) {
        return ObjectSelector<UserBean>(
          objectRepository: _userObjectRepository,
          title: "管理员",
          buildValueText: (BaseBean detail) {
            return (detail as UserBean).username;
          },
          object: widget.manager != null
              ? (UserBean()..id = widget.manager.user)
              : null,
          //controller: _techModalSelectController,
          onSelectCallBack: (BaseBean value) {
            print("---------------$userId");
            userId = value.id;
          },
          objectSelectDialog: ObjectSelectDialog(tobeSelectList: [
            ObjectTobeSelect<UserBean>(
                title: "用户",
                buildQueryParam: (BaseBean t) {
                  return null;
                },
                objectRepository: _userObjectRepository,
                buildObjectItem: (BaseBean t) {
                  return Text(((t as UserBean).username));
                }),
          ]),
        );
      },
      buildObject: (){
//        if(widget.manager!=null){
//          manager.user = userId;
//          print("${manager.user}, ${manager.organization}");
//        }
        manager.user = userId;
        return manager;
      },
    );
  }
}
