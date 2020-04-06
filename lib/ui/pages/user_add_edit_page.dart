import 'package:flutter/material.dart';
import 'package:manufacture/beans/user_bean.dart';
import 'package:manufacture/beans/base_bean.dart';
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
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _mobileController = new TextEditingController();
  bool is_superuser = false;
  bool is_staff = false;
  bool is_active = false;
  bool is_admin = false;

  @override
  void initState() {
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
          ],
        );
      },
    );
  }
}
