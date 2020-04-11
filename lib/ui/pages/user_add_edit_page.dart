import 'package:flutter/material.dart';
import 'package:manufacture/beans/department.dart';
import 'package:manufacture/beans/role.dart';
import 'package:manufacture/beans/user_bean.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/data/repository/department_repository.dart';
import 'package:manufacture/data/repository/role_repository.dart';
import '../../core/object_add_edit_page.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import '../../core/object_select_widget.dart';

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
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  bool is_superuser = false;
  bool is_staff = false;
  bool is_active = false;

  ObjectSelectController<Department> _departmentSelectController =
      new ObjectSelectController<Department>();
  DepartmentRepository _departmentObjectRepository;
  ObjectSelectController<Role> _roleSelectController =
      new ObjectSelectController<Role>();
  RoleRepository _roleObjectRepository;

  @override
  void initState() {
    _departmentObjectRepository = DepartmentRepository.init();
    _roleObjectRepository = RoleRepository.init();
    if (widget.object != null) {
      print(widget.object);
      _userNameController.text = widget.object.username;
      _firstNameController.text = widget.object.first_name;
      _lastNameController.text = widget.object.last_name;
      _mobileController.text = widget.object.mobile;
      is_superuser = widget.object.is_superuser;
      is_active = widget.object.is_active;
      is_staff = widget.object.is_staff;
      is_superuser = widget.object.is_superuser;
      _departmentSelectController.selectObject = Department()
        ..id = widget.object.dept;
      _roleSelectController.selectObject = Role()..id = widget.object.role;
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
          print(widget.object);
          widget.object.username = _userNameController.text;
          widget.object.first_name = _firstNameController.text;
          widget.object.last_name = _lastNameController.text;
          widget.object.dept = _departmentSelectController.selectObject.id;
          widget.object.role = _roleSelectController.selectObject.id;
          //     widget.object.password = _passwordController.text;
          widget.object.mobile = _mobileController.text;
          widget.object.is_superuser = is_superuser;
          widget.object.is_active = is_active;
          widget.object.is_staff = is_staff;
          return widget.object;
        } else {
          UserBean object = new UserBean();
          object.username = _userNameController.text;
          object.first_name = _firstNameController.text;
          object.last_name = _lastNameController.text;
          object.mobile = _mobileController.text;
          object.is_active = is_active;
          object.is_staff = is_staff;
          object.is_superuser = is_superuser;
          object.dept = _departmentSelectController.selectObject.id;
          object.role = _roleSelectController.selectObject.id;
          object.password = _passwordController.text;
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
            widget.object == null
                ? TextFormField(
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
                  )
                : Container(),
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
            ListTile(
              leading: Text("部门"),
              dense: true,
              title: ObjectSelect<Department>(
                controller: _departmentSelectController,
                objectRepository: _departmentObjectRepository,
                onItemShowName: (BaseBean value) {
                  return (value as Department).name;
                },
              ),
            ),
            SizedBox(
              height: 24,
            ),
            ListTile(
              leading: Text("部门"),
              dense: true,
              title: ObjectSelect<Role>(
                controller: _roleSelectController,
                objectRepository: _roleObjectRepository,
                onItemShowName: (BaseBean value) {
                  return (value as Role).name;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
