import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/organization.dart';
import 'package:manufacture/beans/user.dart';
import 'package:manufacture/beans/user_bean.dart';
import 'package:manufacture/core/object_filter_page.dart';
import 'package:manufacture/data/repository/organization_repository.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:manufacture/ui/widget/smart_filter_page/smart_filter_page.dart';
import '../../core/object_manager_page.dart';
import 'user_add_edit_page.dart';
import 'password_change_page.dart';


class UserManager extends StatefulWidget{
  UserManager({Key key}):super(key:key);
  @override
  State<StatefulWidget> createState() => _UserManagerState();
}

class _UserManagerState extends State<UserManager>{
  UserObjectRepository _objectRepository;
  OrganizationObjectRepository _organizationObjectRepository;
  @override
  void initState() {
    _objectRepository = UserObjectRepository.init();
    _organizationObjectRepository = OrganizationObjectRepository.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<UserBean>(
      filterGroupList: [
        FilterGroup(
          niceName: "组织",filterName: "organ",
          builder: (context, func){
            return ObjectFilterPage<Organization>(
              objectRepository: _organizationObjectRepository,
              filterItemChange: func,
              onItemNiceName: (BaseBean result){
                return (result as Organization).name;
              },
            );
          }
        ),
        FilterGroup(
          niceName: "状态",filterName: "is_active",
          filterItems: [
            FilterItem(niceName: "全部",),
            FilterItem(niceName: "激活", filterValue: "1"),
            FilterItem(niceName: "未激活", filterValue: "0"),
          ]
        ),
      ],
      title: "用户管理",
      //initQueryParams: {"unit": widget.unit.id},
      objectRepository:_objectRepository,
      itemWidgetBuilder: (context, BaseBean obj){
        UserBean _userBean = obj as UserBean;
        Widget widget = ListTile(
          leading: ExcludeSemantics(
              child: CircleAvatar(child: Text((_userBean.last_name)==null?_userBean.username[0]:_userBean.last_name.length>0?_userBean.last_name[0]:_userBean.username[0]))),
          title: Builder(builder: (context){
            if((obj as UserBean).first_name!=null && (obj as UserBean).last_name!=null && _userBean.last_name.length>0){
              return Text("${(obj as UserBean).last_name}${(obj as UserBean).first_name}");
            }
            return Text((obj as UserBean).username);
          },),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              (obj as UserBean).position_text!=null?Text((obj as UserBean).position_text):Container(),
              (obj as UserBean).unit_text!=null?Text((obj as UserBean).unit_text):Container(),
              (obj as UserBean).organ_text!=null?Text((obj as UserBean).organ_text):Container(),
            ],
          ),
          trailing: Text((obj as UserBean).is_active?"已激活":"未激活",style: TextStyle(color: (obj as UserBean).is_active?Colors.green:Colors.red),),
        );
        return widget;
      },
      onTap: (BaseBean value){
        print(value as UserBean);
      },
      addEditPageBuilder: (context, BaseBean obj){
        return UserAddEditPage(
          objectRepository: _objectRepository,
          object: obj as UserBean,
        );
      },
      extraBottomItemsBuilder: (context, BaseBean obj){
        return [
          ListTile(
            leading: Icon(
              Icons.edit,
            ),
            title: Text("修改密码"),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return PasswordChangePage(
                  userBean: obj as UserBean,
                  objectRepository: _objectRepository,
                );
              }));
            },
          ),
        ];
      },
    );
  }

}

//import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:manufacture/beans/user.dart';
//import 'package:manufacture/data/repository/user_repository.dart';
//import 'package:manufacture/bloc/user_manager_bloc.dart';
//import 'package:flutter_slidable/flutter_slidable.dart';
//
//class UserManager extends StatefulWidget {
//  final UserRepository userRepository;
//  UserManager({Key key, @required this.userRepository}) : super(key: key);
//  @override
//  State<StatefulWidget> createState() => _UserManagerState();
//}
//
//class _UserManagerState extends State<UserManager> {
//  UserManagerBloc _userManagerBloc;
//  @override
//  void initState() {
//    _userManagerBloc = UserManagerBloc(userRepository: widget.userRepository);
//    _userManagerBloc.dispatch(FetchUserListEvent());
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('用户管理'),
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.insert_chart),
//            onPressed: () {},
//          ),
//          IconButton(
//            icon: Icon(Icons.add),
//            onPressed: () {},
//          ),
//        ],
//      ),
//      body: Builder(builder: (context) {
//        return BlocListener<UserManagerBloc, UserManagerState>(
//          bloc: _userManagerBloc,
//          listener: (context, state) {},
//          child: BlocBuilder(
//              bloc: _userManagerBloc,
//              builder: (context, state) {
//                if (state is LoadedState) {
//                  return ListView(
//                    children: state.userList.map<Slidable>((user) {
//                      return Slidable(
//                        key: new Key(user.username),
//                        closeOnScroll: true,
//                        delegate: new SlidableDrawerDelegate(),
//                        actionExtentRatio: 0.25,
//                        child: new Container(
//                          color: Colors.white,
//                          child: ListTile(
//                            leading: Icon(
//                              Icons.account_circle,
//                              color: Theme.of(context).accentColor,
//                            ),
//                            title: Text(user.name),
//                            subtitle: user.is_superuser?Column(
//                              mainAxisAlignment: MainAxisAlignment.start,
//                              crossAxisAlignment: CrossAxisAlignment.stretch,
//                              children: <Widget>[
//                                Text('超级管理员', style: TextStyle(color: Colors.green),),
//                                Text(user.organization)
//                              ],
//                            ):Text(user.organization),
//                            trailing: user.is_active
//                                ? Text(
//                                    '有效',
//                                    style: TextStyle(color: Colors.green),
//                                  )
//                                : Text(
//                                    '无效',
//                                    style: TextStyle(color: Colors.red),
//                                  ),
//                            onTap: () {},
//                          ),
//                        ),
//                        secondaryActions: <Widget>[
//                          user.is_active
//                              ? new IconSlideAction(
//                                  caption: '设置无效',
//                                  color: Colors.red,
//                                  icon: Icons.airplanemode_active,
//                                  onTap: () {
//                                    Scaffold.of(context).showSnackBar(
//                                      SnackBar(
//                                        content: Text('deactive'),
//                                        backgroundColor: Colors.green,
//                                      ),
//                                    );
//                                  },
//                                )
//                              : new IconSlideAction(
//                                  caption: '激活',
//                                  color: Colors.green,
//                                  icon: Icons.airplanemode_active,
//                                  onTap: () {
//                                    Scaffold.of(context).showSnackBar(
//                                      SnackBar(
//                                        content: Text('active'),
//                                        backgroundColor: Colors.green,
//                                      ),
//                                    );
//                                  },
//                                ),
////                          new IconSlideAction(
////                            caption: '删除',
////                            color: Colors.red,
////                            icon: Icons.delete,
////                            onTap: () {
////                              print("-----delete-----");
////                              Scaffold.of(context).showSnackBar(
////                                SnackBar(
////                                  content: Text('Delete'),
////                                  backgroundColor: Colors.green,
////                                ),
////                              );
////                            },
////                          ),
//                        ],
//                      );
//                    }).toList(),
//                  );
//                } else {
//                  return Center(child: CircularProgressIndicator());
//                }
//              }),
//        );
//      }),
//    );
//  }
//}
