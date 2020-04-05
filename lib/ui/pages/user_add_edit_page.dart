import 'package:flutter/material.dart';
import 'package:manufacture/beans/user_bean.dart';
import 'package:manufacture/beans/organization.dart';
import 'package:manufacture/data/repository/position_repository.dart';
import 'package:manufacture/data/repository/unit_repository.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:manufacture/data/repository/organization_repository.dart';
import 'package:manufacture/beans/base_bean.dart';
import '../../core/object_add_edit_page.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import '../../core/object_select_widget.dart';

class _OrganizationPositionSelect extends StatefulWidget {
  final OrganizationObjectRepository organizationObjectRepository;
  final ObjectSelectController<Organization> organizationSelectController;
  final PositionObjectRepository positionObjectRepository;
  final ObjectSelectController<Position> positionSelectController;
  final UnitObjectRepository unitObjectRepository;
  final ObjectSelectController<Unit> unitSelectController;

  _OrganizationPositionSelect(
      {Key key,
      this.unitObjectRepository,
      this.unitSelectController,
      this.organizationSelectController,
      this.organizationObjectRepository,
      this.positionSelectController,
      this.positionObjectRepository})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrganizationPositionSelectState();
}

class _OrganizationPositionSelectState
    extends State<_OrganizationPositionSelect> {

  Map<String, dynamic> _unitQueryParams={};
  Map<String, dynamic> _positionQueryParams={};
  GlobalKey<ObjectSelectPageState> _unitKey =
  new GlobalKey<ObjectSelectPageState>();
  GlobalKey<ObjectSelectPageState> _positionKey =
  new GlobalKey<ObjectSelectPageState>();

  @override
  void initState() {
    if(widget.organizationSelectController.selectObject!=null)
      _unitQueryParams['organization'] = widget.organizationSelectController.selectObject.id;
    if(widget.positionSelectController.selectObject!=null)
      _positionQueryParams['unit'] = widget.unitSelectController.selectObject.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Text("组织"),
          dense: true,
          title: ObjectSelect<Organization>(
            controller: widget.organizationSelectController,
            objectRepository: widget.organizationObjectRepository,
            onItemShowName: (BaseBean value) {
              return (value as Organization).name;
            },
            onSelectCallBack: (BaseBean value){
              _unitQueryParams.clear();
              _unitQueryParams['organization'] = (value as Organization).id;
              _unitKey.currentState.reload(_unitQueryParams);
            },
          ),
        ),
        ListTile(
          leading: Text("部门"),
          dense: true,
          title: ObjectSelect<Unit>(
            key: _unitKey,
            controller: widget.unitSelectController,
            initQueryParams: _unitQueryParams,
            objectRepository: widget.unitObjectRepository,
            onItemShowName: (BaseBean value) {
              return (value as Unit).name;
            },
            onSelectCallBack: (BaseBean value){
              _positionQueryParams.clear();
              _positionQueryParams['unit'] = (value as Unit).id;
              _positionKey.currentState.reload(_positionQueryParams);
            },
          ),
        ),
        ListTile(
          leading: Text("岗位"),
          dense: true,
          title: ObjectSelect<Position>(
            key: _positionKey,
            controller: widget.positionSelectController,
            initQueryParams: _positionQueryParams,
            objectRepository: widget.positionObjectRepository,
            onItemShowName: (BaseBean value) {
              return (value as Position).name;
            },
          ),
        ),
      ],
    );
  }
}

class UserAddEditPage extends StatefulWidget {
  final UserBean object;
  final ObjectRepository<UserBean> objectRepository;
  UserAddEditPage({Key key, this.object, this.objectRepository})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _OrganizationAddEditPageState();
}

class _OrganizationAddEditPageState extends State<UserAddEditPage> {
  TextEditingController _userNameController = new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  bool is_superuser = false;
  bool is_staff = false;
  bool is_active = false;
  bool is_admin = false;
  ObjectSelectController<Position> _positionSelectController =
      new ObjectSelectController<Position>();
  PositionObjectRepository _positionObjectRepository;
  int organization;
  ObjectSelectController<Organization> _organizationSelectController =
      new ObjectSelectController<Organization>();
  OrganizationObjectRepository _organizationObjectRepository;
  ObjectSelectController<Unit> _unitSelectController =
      new ObjectSelectController<Unit>();
  UnitObjectRepository _unitObjectRepository;

  @override
  void initState() {
    _positionObjectRepository = PositionObjectRepository.init();
    _organizationObjectRepository = OrganizationObjectRepository.init();
    _unitObjectRepository = UnitObjectRepository.init();
    if (widget.object != null) {
      print(widget.object);
      _userNameController.text = widget.object.username;
      _firstNameController.text = widget.object.first_name;
      _lastNameController.text = widget.object.last_name;
      _passwordController.text = widget.object.password;
      _mobileController.text = widget.object.mobile;
      _emailController.text = widget.object.email;
      is_superuser = widget.object.is_superuser;
      is_active = widget.object.is_active;
      is_staff = widget.object.is_staff;
      is_superuser = widget.object.is_superuser;
      _positionSelectController.selectObject = Position()
        ..id = widget.object.position;
      _organizationSelectController.selectObject = Organization()
        ..id = widget.object.organ;
      _unitSelectController.selectObject = Unit()..id = widget.object.unit;

    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectAddEditPage<UserBean>(
      object: widget.object,
      objectRepository: widget.objectRepository,
      objectCallback: () {
        if (widget.object != null) {
          widget.object.username = _userNameController.text;
          widget.object.first_name = _firstNameController.text;
          widget.object.last_name = _lastNameController.text;
     //     widget.object.password = _passwordController.text;
          widget.object.mobile = _mobileController.text;
          widget.object.email = _emailController.text;
          widget.object.is_superuser = is_superuser;
          widget.object.is_active = is_active;
          widget.object.is_staff = is_staff;
          widget.object.is_admin = is_admin;
          widget.object.position = _positionSelectController.selectObject.id;
          widget.object.organ = _organizationSelectController.selectObject.id;
          widget.object.unit = _unitSelectController.selectObject.id;
          return widget.object;
        } else {
          UserBean object = new UserBean();
          object.username = _userNameController.text;
          object.first_name = _firstNameController.text;
          object.last_name = _lastNameController.text;
          object.password = _passwordController.text;
          object.mobile = _mobileController.text;
          object.email = _emailController.text;
          object.is_admin = is_admin;
          object.is_active = is_active;
          object.is_staff = is_staff;
          object.is_superuser = is_superuser;
          object.position = _positionSelectController.selectObject.id;
          object.organ = _organizationSelectController.selectObject.id;
          object.unit = _unitSelectController.selectObject.id;
          return object;
        }
      },
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 24,
            ),
            TextFormField(
              controller: _userNameController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                icon: Icon(
                  Icons.code,
                  color: Theme.of(context).accentColor,
                ),
                labelText: '用户名',
                //hintText: '编号',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            SizedBox(
              height: 24,
            ),
            widget.object==null?TextFormField(
              controller: _passwordController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                icon: Icon(
                  Icons.mode_edit,
                  color: Theme.of(context).accentColor,
                ),
                labelText: '密码',
                //hintText: '编号',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ):Container(),
            SizedBox(
              height: 24,
            ),
            TextFormField(
              controller: _lastNameController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                icon: Icon(
                  Icons.assignment_ind,
                  color: Theme.of(context).accentColor,
                ),
                labelText: '姓',
                //hintText: '编号',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            SizedBox(
              height: 24,
            ),
            TextFormField(
              controller: _firstNameController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                icon: Icon(
                  Icons.account_circle,
                  color: Theme.of(context).accentColor,
                ),
                labelText: '名',
                //hintText: '编号',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            SizedBox(
              height: 24,
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                icon: Icon(
                  Icons.assignment,
                  color: Theme.of(context).accentColor,
                ),
                labelText: '邮箱',
                //hintText: '编号',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            SizedBox(
              height: 24,
            ),
            TextFormField(
              controller: _mobileController,
              validator: (value) {
                if (value.isEmpty) {
                  return "内容不能为空";
                }
                return null;
              },
              decoration: InputDecoration(
                filled: true,
                icon: Icon(
                  Icons.phone,
                  color: Theme.of(context).accentColor,
                ),
                labelText: '电话',
                //hintText: '编号',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: is_admin,
                        onChanged: (val) {
                          setState(() {
                            is_admin = val;
                          });
                        },
                      ),
                      Text("管理员"),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: is_active,
                        onChanged: (val) {
                          setState(() {
                            is_active = val;
                          });
                        },
                      ),
                      Text("激活"),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: is_staff,
                        onChanged: (val) {
                          setState(() {
                            is_staff = val;
                          });
                        },
                      ),
                      Text("职员"),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: is_superuser,
                        onChanged: (val) {
                          setState(() {
                            is_superuser = val;
                          });
                        },
                      ),
                      Text("超级管理员"),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
//            ListTile(
//              leading: Text("岗位"),
//              dense: true,
//              title: ObjectSelect<Position>(
//                controller: _positionSelectController,
//                objectRepository: _positionObjectRepository,
//                onItemShowName: (BaseBean value) {
//                  return (value as Position).name;
//                },
//              ),
//            ),
            _OrganizationPositionSelect(
              organizationObjectRepository: _organizationObjectRepository,
              organizationSelectController: _organizationSelectController,
              positionObjectRepository: _positionObjectRepository,
              positionSelectController: _positionSelectController,
              unitObjectRepository: _unitObjectRepository,
              unitSelectController: _unitSelectController,
            ),
          ],
        );
      },
    );
  }
}
