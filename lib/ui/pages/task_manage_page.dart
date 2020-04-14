import 'package:flutter/material.dart';


class Tasks extends StatefulWidget {
  @override
  _TasksState createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class TaskMangePage extends StatefulWidget {
  @override
  _TaskMangePageState createState() => _TaskMangePageState();
}

class _TaskMangePageState extends State<TaskMangePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("任务单"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () => debugPrint('Search button is pressed'),
            ),
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(text: "已完成",),
              Tab(text: "未完成",),
            ],

          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Icon(Icons.local_florist, size: 128.0, color: Colors.black12),
            Icon(Icons.change_history, size: 128.0, color: Colors.black12),
          ],
        ),
      ),

    );
  }
}
