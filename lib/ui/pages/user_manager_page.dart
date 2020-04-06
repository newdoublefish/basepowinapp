import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/user_bean.dart';
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
  @override
  void initState() {
    _objectRepository = UserObjectRepository.init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<UserBean>(
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
