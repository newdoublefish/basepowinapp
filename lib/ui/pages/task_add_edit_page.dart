import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/procedure.dart';
import 'package:manufacture/beans/task.dart';
import 'package:manufacture/beans/user_bean.dart';
import 'package:manufacture/core/object_add_edit_page.dart';
import 'package:manufacture/core/object_select_widget.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import 'package:manufacture/data/repository/user_repository.dart';

class TaskAddEditPage extends StatefulWidget {
  final Procedure procedure;
  final Task task;
  final ObjectRepository objectRepository;

  TaskAddEditPage({Key key, this.procedure, this.task, this.objectRepository})
      : super(key: key);

  @override
  _TaskAddEditPageState createState() => _TaskAddEditPageState();
}

class _TaskAddEditPageState extends State<TaskAddEditPage> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _planController = new TextEditingController();

  ObjectSelectController<UserBean> _userSelectController =
      new ObjectSelectController<UserBean>();
  UserObjectRepository _userObjectRepository;

  @override
  void initState() {
    _userObjectRepository = UserObjectRepository.init();
    if (widget.task!=null){
      _nameController.text = widget.task.name;
      _planController.text = "${widget.task.plan_quantity}";
      _userSelectController.selectObject = UserBean()..id=widget.task.user;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectAddEditPage<Task>(
      object: widget.task,
      objectRepository: widget.objectRepository,
      objectCallback: () {
        if (widget.task != null) {
          widget.task.name = _nameController.text.toString();
          widget.task.plan_quantity = int.parse(_planController.text.toString());
          widget.task.quantity = int.parse(_planController.text.toString());
          widget.task.user = _userSelectController.selectObject.id;
          return widget.task;
        }else{
          Task task = Task();
          task.name = _nameController.text.toString();
          task.plan_quantity = int.parse(_planController.text.toString());
          task.user = _userSelectController.selectObject.id;
          task.procedure = widget.procedure.id;
          task.quantity = task.plan_quantity;
          task.weight = 1.0;
          return task;
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
              controller: _nameController,
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
                labelText: '任务名称',
                //hintText: '编号',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            SizedBox(
              height: 24,
            ),
            TextFormField(
              controller: _planController,
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
                labelText: '数量',
                //hintText: '编号',
                //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
              ),
            ),
            SizedBox(
              height: 24,
            ),
            ListTile(
              leading: Text("操作人员"),
              dense: true,
              title: ObjectSelect<UserBean>(
                controller: _userSelectController,
                objectRepository: _userObjectRepository,
                onItemShowName: (BaseBean value) {
                  return (value as UserBean).name;
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
