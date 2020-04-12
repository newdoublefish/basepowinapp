import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/department.dart';
import 'package:manufacture/beans/mop.dart';
import 'package:manufacture/beans/user_bean.dart';
import 'package:manufacture/core/object_filter_page.dart';
import 'package:manufacture/data/repository/department_repository.dart';
import 'package:manufacture/data/repository/mop_repository.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:manufacture/ui/pages/procedure_manager_page.dart';
import 'package:manufacture/ui/widget/smart_filter_page/smart_filter_page.dart';
import '../../core/object_manager_page.dart';
import 'user_add_edit_page.dart';
import 'password_change_page.dart';


class MopManager extends StatefulWidget{
  MopManager({Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() => _MopManagerState();
}

class _MopManagerState extends State<MopManager>{
  MopRepository _objectRepository;
  @override
  void initState() {
    _objectRepository = MopRepository.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Mop>(
      filterGroupList: [
        FilterGroup(
            niceName: "状态",filterName: "is_active",
            filterItems: [
              FilterItem(niceName: "全部",),
              FilterItem(niceName: "激活", filterValue: "1"),
              FilterItem(niceName: "未激活", filterValue: "0"),
            ]
        ),
      ],
      title: "流程管理",
      //initQueryParams: {"unit": widget.unit.id},
      objectRepository:_objectRepository,
      itemWidgetBuilder: (context, BaseBean obj){
        Mop _mop = obj as Mop;
        Widget widget = ListTile(
          leading: ExcludeSemantics(
              child: CircleAvatar(child: Text(_mop.manufacture_order_name[0]))),
          title: Builder(builder: (context){
            return Text(_mop.manufacture_order_name);
          },),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
//              (obj as UserBean).dept_name!=null?Text((obj as UserBean).dept_name):Container(),
//              (obj as UserBean).role_name!=null?Text((obj as UserBean).role_name):Container(),
            ],
          ),
          //trailing: Text((obj as UserBean).is_active?"已激活":"未激活",style: TextStyle(color: (obj as UserBean).is_active?Colors.green:Colors.red),),
        );
        return widget;
      },
      onTap: (BaseBean value){
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return ProcedureManager(mop: value as Mop,);
        }));
      },
//      addEditPageBuilder: (context, BaseBean obj){
//        return UserAddEditPage(
//          objectRepository: _objectRepository,
//          object: obj as UserBean,
//        );
//      },
//      extraBottomItemsBuilder: (context, BaseBean obj){
//        return [
//          ListTile(
//            leading: Icon(
//              Icons.edit,
//            ),
//            title: Text("修改密码"),
//            onTap: () {
//              Navigator.pop(context);
//              Navigator.push(context, MaterialPageRoute(builder: (context){
//                return PasswordChangePage(
//                  userBean: obj as UserBean,
//                  objectRepository: _objectRepository,
//                );
//              }));
//            },
//          ),
//        ];
//      },
    );
  }

}
