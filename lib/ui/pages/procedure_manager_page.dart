import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/mop.dart';
import 'package:manufacture/beans/procedure.dart';
import 'package:manufacture/core/object_add_edit_page.dart';
import 'package:manufacture/core/object_filter_page.dart';
import 'package:manufacture/data/repository/department_repository.dart';
import 'package:manufacture/data/repository/mop_repository.dart';
import 'package:manufacture/data/repository/procedure_repository.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:manufacture/ui/pages/procedure_home.dart';
import 'package:manufacture/ui/widget/railway/railway.dart';
import 'package:manufacture/ui/widget/smart_filter_page/smart_filter_page.dart';
import '../../core/object_manager_page.dart';
import 'task_manage_page.dart';
import 'user_add_edit_page.dart';
import 'password_change_page.dart';

class ProcedureManager extends StatefulWidget {
  final Mop mop;

  ProcedureManager({Key key, this.mop}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProcedureManagerState();
}

class _ProcedureManagerState extends State<ProcedureManager> {
  ProcedureRepository _objectRepository;

  @override
  void initState() {
    _objectRepository = ProcedureRepository.init();
    super.initState();
  }

  Widget _actionButton(String actionName, Icon icon,
      VoidCallback callback) {
    return PopupMenuItem(
      child: ListTile(
        leading: icon != null ? Icon(Icons.forward) : icon,
        title: Text(actionName),
        onTap: (){
          callback();
          Navigator.pop(context);
        },
      ),
    );
  }

  ListTile _procedureNum(String name, int cnt){
    return ListTile(dense:true,leading: Text(name),title:Text("$cnt"),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("流程"),
        ),
        body: Builder(
          builder: (context) {
            return ObjectManagerPage<Procedure>.custom(
              title: "流程",
              enablePullUp: false,
              initQueryParams: {"mop": widget.mop.id},
              objectRepository: _objectRepository,
              customWidgetBuilder: (context, List<BaseBean> list) {
                print(list);
                return RailWay(
                  physics: NeverScrollableScrollPhysics(),

                  stations: list.map((node) {
                    print(node);
                    Procedure _procedure = node as Procedure;
                    return Station(
                        onTap: (){
                          print("--------onTap-------");
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            //return ProcedureHomePage(procedure: _procedure,);
                            return TaskMangePage(procedure: _procedure);
                          }));
                        },
                        title: _procedure.name,
                        content: Column(
                          children: <Widget>[
                            _procedureNum("接收", _procedure.received_quantity),
                            _procedureNum("完成", _procedure.quantity),
                            _procedureNum("发送", _procedure.delivered_quantity),
                          ],
                        ),
                        actionBuilder: (context, int) {
                          return PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context) => <PopupMenuItem>[
                              _actionButton("发送", Icon(Icons.forward), (){
                                  print("发送:"+_procedure.name);
                              }),
                              _actionButton("接收", Icon(Icons.forward), (){

                              }),
                              _actionButton("派工", Icon(Icons.forward), (){

                              }),
                            ],
                          );
                        });
                  }).toList(),
                );
              },
//      itemWidgetBuilder: (context, BaseBean obj) {
//        Procedure _procedure = obj as Procedure;
//        Widget widget = ListTile(
//          leading: ExcludeSemantics(
//              child: CircleAvatar(child: Text(_procedure.name[0]))),
//          title: Builder(
//            builder: (context) {
//              return Text(_procedure.name);
//            },
//          ),
//          subtitle: Column(
//            mainAxisSize: MainAxisSize.min,
//            mainAxisAlignment: MainAxisAlignment.start,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
//            children: <Widget>[
////              (obj as UserBean).dept_name!=null?Text((obj as UserBean).dept_name):Container(),
////              (obj as UserBean).role_name!=null?Text((obj as UserBean).role_name):Container(),
//            ],
//          ),
//          trailing: PopupMenuButton(
//            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
//              PopupMenuItem<String>(
//                value: "insertUp",
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Icon(
//                      Icons.file_upload,
//                      color: Theme.of(context).accentColor,
//                    ),
//                    Container(
//                      margin: const EdgeInsets.all(10),
//                      child: Text('发送'),
//                    )
//                  ],
//                ),
//              ),
//              PopupMenuItem<String>(
//                value: "insertDown",
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Icon(
//                      Icons.file_download,
//                      color: Theme.of(context).accentColor,
//                    ),
//                    Container(
//                      margin: const EdgeInsets.all(10),
//                      child: Text('接收'),
//                    )
//                  ],
//                ),
//              ),
//              PopupMenuItem<String>(
//                value: "up",
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.start,
//                  crossAxisAlignment: CrossAxisAlignment.center,
//                  children: <Widget>[
//                    Icon(
//                      Icons.arrow_upward,
//                      color: Theme.of(context).accentColor,
//                    ),
//                    Container(
//                      margin: const EdgeInsets.all(10),
//                      child: Text('派工'),
//                    )
//                  ],
//                ),
//              ),
//            ],
//            onSelected: (String action) {},
//          ),
//          //trailing: Text((obj as UserBean).is_active?"已激活":"未激活",style: TextStyle(color: (obj as UserBean).is_active?Colors.green:Colors.red),),
//        );
//        return widget;
//      },
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
          },
        ));
  }
}
