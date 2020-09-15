import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  ObjectManagerController _objectManagerController;

  @override
  void initState() {
    _objectRepository = ProcedureRepository.init();
    _objectManagerController = ObjectManagerController("refresh");
    super.initState();
  }

  Widget _actionButton(String actionName, Icon icon, VoidCallback callback) {
    return PopupMenuItem(
      child: ListTile(
        leading: icon != null ? Icon(Icons.forward) : icon,
        title: Text(actionName),
        onTap: () {
          Navigator.pop(context);
          callback();
        },
      ),
    );
  }

  ListTile _procedureNum(String name, int cnt) {
    return ListTile(
      dense: true,
      leading: Text(name),
      title: Text("$cnt"),
    );
  }

  Future<void> _receive(Procedure procedure, int count) async{
    bool flag = await _objectRepository.receive(procedure: procedure, quantity: count);
    if (flag){
      _objectManagerController.requestRefresh();
      print("接收成功");
    }else{
      print("接收失败");
    }

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
              objectManagerController: _objectManagerController,
              customWidgetBuilder: (context, List<BaseBean> list) {
                print(list);
                return RailWay(
                  physics: NeverScrollableScrollPhysics(),
                  stations: list.map((node) {
                    print(node);
                    Procedure _procedure = node as Procedure;
                    return Station(
                        onTap: () {
                          print("--------onTap-------");
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            //return ProcedureHomePage(procedure: _procedure,);
                            return TaskMangePage(procedure: _procedure);
                          }));
                        },
                        title: _procedure.name,
                        content: Column(
                          children: <Widget>[
                            _procedureNum("接收", _procedure.received_quantity),
                            _procedureNum("完成", _procedure.quantity),
                            //_procedureNum("发送", _procedure.delivered_quantity),
                          ],
                        ),
                        actionBuilder: (context, index) {
                          TextEditingController _countController =
                              new TextEditingController();
                          return PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context) => <PopupMenuItem>[
                              _actionButton("开始", Icon(Icons.forward), () {
                                print("开始:" + _procedure.name);
                              }),
                              _actionButton("结束", Icon(Icons.forward), () {
                                print("结束:" + _procedure.name);
                              }),
                              _actionButton("接收", Icon(Icons.forward), () {
                                print("接收:" + _procedure.name);
                                showDialog(
                                    builder: (context) => new AlertDialog(
                                          title: new Text('输入接收数量'),
                                          content: Builder(
                                            builder: (context) {
                                              return TextField(
                                                controller: _countController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  WhitelistingTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration: InputDecoration(
                                                  filled: true,
                                                  icon: Icon(
                                                    Icons.account_balance,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                  labelText: '数量',
                                                  //hintText: '编号',
                                                  //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
                                                ),
                                              );
                                            },
                                          ),
                                          actions: <Widget>[
                                            new FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  _receive(_procedure, int.parse(_countController.text));
                                                },
                                                child: new Text('确定')),
                                            new FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: new Text('取消'))
                                          ],
                                        ),
                                    context: context);
                              }),
                              //_actionButton("派工", Icon(Icons.forward), () {}),
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
