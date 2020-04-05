import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/project_respository.dart';
import 'package:manufacture/ui/pages/project_detail_manager_page.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'project_add_edit_page.dart';
import '../../core/object_manager_page.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/ui/widget/smart_filter_page/smart_filter_page.dart';

class WorkPage extends StatefulWidget {
  final UserRepository userRepository;
  final bool canEdit;
  WorkPage({Key key, @required this.userRepository, this.canEdit = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => WorkPageState();
}

class WorkPageState extends State<WorkPage> with AutomaticKeepAliveClientMixin {
  ProjectObjectRepository _projectObjectRepository;
  @override
  void initState() {
    _projectObjectRepository = ProjectObjectRepository.init();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Project>(
      title: "项目管理",
      filterGroupList: [
        FilterGroup(niceName: "项目状态", filterName: "status", filterItems: [
          FilterItem(
            niceName: "全部",
          ),
          FilterItem(niceName: "未开始", filterValue: "0"),
          FilterItem(niceName: "进行中", filterValue: "1"),
          FilterItem(niceName: "结束", filterValue: "2"),
        ]),
      ],
      objectRepository: _projectObjectRepository,
      itemWidgetBuilder: (context, BaseBean obj) {
        Widget widget = Container(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Theme.of(context).accentColor,
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.album),
                    title: Text((obj as Project).code),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text((obj as Project).name),
                        Text((obj as Project).start)
                      ],
                    ),
                    trailing: Text(Project.getStatus((obj as Project).status)),
                  ),
                )
              ]),
            ));
        return widget;
      },
      onTap: (BaseBean value) {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return new DetailMangerPage(
            project: value as Project,
            userRepository: widget.userRepository,
          );
        }));
      },
      addEditPageBuilder: (context, BaseBean obj) {
        return ProjectAddEditPage(
          objectRepository: _projectObjectRepository,
          project: obj as Project,
        );
      },
    );
  }
}