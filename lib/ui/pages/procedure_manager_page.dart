import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/mop.dart';
import 'package:manufacture/beans/procedure.dart';
import 'package:manufacture/core/object_filter_page.dart';
import 'package:manufacture/data/repository/department_repository.dart';
import 'package:manufacture/data/repository/mop_repository.dart';
import 'package:manufacture/data/repository/procedure_repository.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:manufacture/ui/widget/smart_filter_page/smart_filter_page.dart';
import '../../core/object_manager_page.dart';
import 'user_add_edit_page.dart';
import 'password_change_page.dart';


class ProcedureManager extends StatefulWidget{
  final Mop mop;
  ProcedureManager({Key key,this.mop}):super(key:key);
  @override
  State<StatefulWidget> createState() => _ProcedureManagerState();
}

class _ProcedureManagerState extends State<ProcedureManager>{
  ProcedureRepository _objectRepository;
  @override
  void initState() {
    _objectRepository = ProcedureRepository.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Procedure>(
      title: "流程",
      //initQueryParams: {"unit": widget.unit.id},
      objectRepository:_objectRepository,
      itemWidgetBuilder: (context, BaseBean obj){
        Procedure _procedure = obj as Procedure;
        Widget widget = ListTile(
          leading: ExcludeSemantics(
              child: CircleAvatar(child: Text(_procedure.name[0]))),
          title: Builder(builder: (context){
            return Text(_procedure.name);
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
        //print(value as UserBean);
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
