import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/procedure.dart';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/beans/task.dart';
import 'package:manufacture/core/object_manager_page.dart';
import 'package:manufacture/data/repository/task_repository.dart';
import 'package:manufacture/ui/widget/smart_filter_page/smart_filter_page.dart';
import 'package:manufacture/util/snackbar_util.dart';

import 'task_add_edit_page.dart';

class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  TaskRepository _taskRepository;

  getList() async {
    _taskRepository.clear();
    ReqResponse<List<Task>> req = await _taskRepository.getList();
    print(req.t);
  }

  @override
  void initState() {
    _taskRepository = TaskRepository.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Task>.custom(
      objectRepository: _taskRepository,
      customWidgetBuilder: (context, List<BaseBean> list) {
        print(list.length);
        return Column(
          children: list.map((obj) {
            print("111 ${obj.id}");
            Task _task = obj as Task;
            return Card(
              child: ListTile(
                title: Text(_task.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text("状态: ${_task.status_text}"),
                    Text("数量: ${_task.quantity}"),
                    Text("开始: ${_task.started_at}"),
                    Text("结束: ${_task.stopped_at}"),
                    Text("操作: ${_task.username}"),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class TaskMangePage extends StatefulWidget {
  final Procedure procedure;

  TaskMangePage({Key key, this.procedure}) : super(key: key);

  @override
  _TaskMangePageState createState() => _TaskMangePageState();
}

class _TaskMangePageState extends State<TaskMangePage> {
  TaskRepository _objectRepository;
  ObjectManagerController objectManagerController;

  @override
  void initState() {
    _objectRepository = TaskRepository.init();
    objectManagerController = ObjectManagerController("refresh");
    super.initState();
  }

  Widget _actionButton(String actionName, Icon icon, VoidCallback callback) {
    return PopupMenuItem(
      child: ListTile(
        leading: icon != null ? Icon(Icons.forward) : icon,
        title: Text(actionName),
        onTap: () {
          callback();
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Task>(
      filterGroupList: [
        FilterGroup(niceName: "状态", filterName: "status", filterItems: [
          FilterItem(
            niceName: "全部",
          ),
          FilterItem(niceName: "未开始", filterValue: "0"),
          FilterItem(niceName: "进行中", filterValue: "1"),
          FilterItem(niceName: "已完成", filterValue: "2"),
        ]),
      ],
      objectManagerController: objectManagerController,
      title: "任务管理",
      initQueryParams: {"procedure": widget.procedure.id},
      objectRepository: _objectRepository,
      itemWidgetBuilder: (context, BaseBean obj) {
        Task _task = obj as Task;
        Widget widget = Card(
          color: _getTaskColor(_task),
          child: ListTile(
            title: Text(_task.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("状态: ${_task.status_text}"),
                Text("数量: ${_task.quantity}"),
                Text("开始: ${_task.started_at}"),
                Text("结束: ${_task.stopped_at}"),
                Text("操作: ${_task.username}"),
              ],
            ),
            trailing: PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => <PopupMenuItem>[
                _actionButton("开始", Icon(Icons.forward), () async {
                  ReqResponse response =
                      await _objectRepository.start(task: _task);
                  if (response.isSuccess) {
                    objectManagerController.requestRefresh();
                  }else{
                    SnackBarUtil.fail(context: context, message: response.message);
                  }
                }),
                _actionButton("完成", Icon(Icons.forward), () async{
                  ReqResponse response =
                  await _objectRepository.finish(task: _task);
                  if (response.isSuccess) {
                    objectManagerController.requestRefresh();
                  }else{
                    SnackBarUtil.fail(context: context, message: response.message);
                  }
                }),
              ],
            ),
          ),
        );
        return widget;
      },
      addEditPageBuilder: (context, BaseBean obj) {
        return TaskAddEditPage(
          task: obj as Task,
          procedure: widget.procedure,
          objectRepository: _objectRepository,
        );
      },
      canDeleteBatch: false,
      onTap: (BaseBean value) {
//        Navigator.push(context, MaterialPageRoute(builder: (context){
//          return ProcedureManager(mop: value as Mop,);
//        }));
      },
    );
  }

  Color _getTaskColor(Task task) {
    if(task.status_text.compareTo("未开始")==0){
      return Colors.redAccent;
    }else if(task.status_text.compareTo("进行中")==0){
      return Colors.yellowAccent;
    }
    return Colors.greenAccent;
  }
}

//class _TaskMangePageState extends State<TaskMangePage> {
//  @override
//  Widget build(BuildContext context) {
//    return DefaultTabController(
//      length: 2,
//      child: Scaffold(
//        appBar: AppBar(
//          title: Text("任务单"),
//          actions: <Widget>[
//            IconButton(
//              icon: Icon(Icons.search),
//              tooltip: 'Search',
//              onPressed: () => debugPrint('Search button is pressed'),
//            ),
//          ],
//          bottom: TabBar(
//            tabs: <Widget>[
//              Tab(text: "已完成",),
//              Tab(text: "未完成",),
//            ],
//
//          ),
//        ),
//        body: TabBarView(
//          children: <Widget>[
//            Tasks(),
//            Icon(Icons.change_history, size: 128.0, color: Colors.black12),
//          ],
//        ),
//      ),
//    );
//  }
//}
