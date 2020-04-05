import 'package:flutter/material.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/detail_repository.dart';
import 'package:manufacture/ui/pages/node_operate_page.dart';
import 'package:manufacture/data/repository/user_repository.dart';

import 'flow_instance_manager_page.dart';
import '../../core/object_manager_page.dart';
import 'progress_status_page.dart';

class TaskManage extends StatefulWidget {
  final UserRepository userRepository;
  TaskManage({Key key, this.userRepository}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TaskManage> with AutomaticKeepAliveClientMixin {
  DetailObjectRepository _detailObjectRepository;
  @override
  void initState() {
    _detailObjectRepository = DetailObjectRepository.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ObjectManagerPage<Detail>(
      title: "任务管理",
      initQueryParams: {"project__status": "1"},
      objectRepository: _detailObjectRepository,
      canDeleteBatch: false,
      canDeleteSingle: false,
      canAddEditObject: false,
      itemWidgetBuilder: (context, BaseBean obj) {
        Widget _widget = Container(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            //color: Theme.of(context).accentColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ListTile(
                    leading: ExcludeSemantics(
                        child:
                            CircleAvatar(child: Text((obj as Detail).name[0]))),
                    title: Text((obj as Detail).name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text('数量 ${(obj as Detail).count}'),
                        Text('厂家 ${(obj as Detail).odm_name}'),
                        Text('项目 ${(obj as Detail).project_name}'),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    FlatButton(
                      //color: Theme.of(context).accentColor,
                      child: Text("工序"),
                      onPressed: (){
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (BuildContext context) {
                              return new NodeOperate(
                                procedure: (obj as Detail).flow,
                              );
                            }));
                      },
                    ),FlatButton(
                      //color: Theme.of(context).accentColor,
                      child: Text("进度"),
                      onPressed: (){
                        Navigator.push(context,
                            new MaterialPageRoute(builder: (BuildContext context) {
                              return new ProgressStatus(
                                detail: obj as Detail,
                              );
                            }));
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        );
        return _widget;
      },
      onTap: (BaseBean value) {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return FlowInstanceManager(
            canDeleteBatch: false,
            canDeleteSingle: false,
            canAddEditObject: false,
            detail: value as Detail,
            userRepository: widget.userRepository,
          );
        }));
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
