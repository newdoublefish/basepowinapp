import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/detail_repository.dart';
import 'progress_status_page.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'flow_instance_manager_page.dart';
import '../../core/object_manager_page.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'project_detail_add_edit_page.dart';

class DetailMangerPage extends StatefulWidget {
  final Project project;
  final UserRepository userRepository;
  final bool canEdit;
  DetailMangerPage(
      {Key key,
      @required this.project,
      @required this.userRepository,
      this.canEdit = false})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _DetailMangerPageState();
}

class _DetailMangerPageState extends State<DetailMangerPage> {
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
      initQueryParams: {"project": widget.project.id},
      objectRepository: _detailObjectRepository,
      itemWidgetBuilder: (context, BaseBean obj) {
        Widget widget = ListTile(
          leading: ExcludeSemantics(
              child: CircleAvatar(child: Text((obj as Detail).name[0]))),
          title: Text((obj as Detail).name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
//              Text('类型 ${(obj as Detail).category}'),
              Text('数量 ${(obj as Detail).count}'),
              Text('厂家 ${(obj as Detail).odm}'),
              Text('备注 ${(obj as Detail).remark}'),
            ],
          ),
          trailing: MaterialButton(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.insert_chart,
                    color: Colors.green,
                  ),
                  Text("进度查看"),
                ],
              ),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return new ProgressStatus(
                    detail: obj as Detail,
                  );
                }));
              }),
        );
        return widget;
      },
      onTap: (BaseBean value) {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return FlowInstanceManager(
            detail: value as Detail,
            userRepository: widget.userRepository,
          );
        }));
      },
      addEditPageBuilder: (context, BaseBean obj) {
        return DetailAddEditPage(
          objectRepository: _detailObjectRepository,
          detail: obj as Detail,
          project: widget.project,
        );
      },
    );
  }
}

//class _DetailMangerPageState extends State<DetailMangerPage> {
//  DetailManagerBloc _detailManagerBloc;
//  ProjectRepository _projectRepository;
//  DetailRepository _detailRepository;
//
//  @override
//  void initState() {
//    _projectRepository = ProjectRepository();
//    _detailRepository = DetailRepository();
//    _detailManagerBloc = DetailManagerBloc(
//        projectRepository: _projectRepository,
//        detailRepository: _detailRepository);
//    _detailManagerBloc.dispatch(FetchProjectDetailEvent(id: widget.project.id));
//    super.initState();
//  }
//
//  @override
//  void dispose() {
//    _detailManagerBloc.dispose();
//    super.dispose();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("生产明细"),
//        actions: <Widget>[
//          widget.canEdit
//              ? Container(
//                  child: IconButton(
//                    icon: Icon(Icons.add),
//                    onPressed: () {
//                      Navigator.push(context,
//                          MaterialPageRoute<bool>(builder: (context) {
//                        return ProjectDetailAddEditPage(
//                          detailRepository: _detailRepository,
//                          type: ProjectDetailAddEditPageType.CREATE,
//                          project: widget.project,
//                        );
//                      })).then((value) {
//                        print(value);
//                        if (value != null) {
//                          if (value)
//                            _detailManagerBloc.dispatch(
//                                FetchProjectDetailEvent(id: widget.project.id));
//                        }
//                      });
//                    },
//                  ),
//                )
//              : Container(),
//        ],
//      ),
//      body: BlocListener<DetailManagerBloc, DetailManagerState>(
//        bloc: _detailManagerBloc,
//        listener: (context, state) {
//          if (state is DoneState) {
//            if (state.isSuccess) {
//              SnackBarUtil.success(context: context, message: state.message);
//            } else {
//              SnackBarUtil.fail(context: context, message: state.message);
//            }
//          }
//        },
//        child: BlocBuilder<DetailManagerBloc, DetailManagerState>(
//            bloc: _detailManagerBloc,
//            condition: (previousState, currentState) {
//              if (currentState is DoneState) {
//                return false;
//              }
//              return true;
//            },
//            builder: (BuildContext context, DetailManagerState state) {
//              return Builder(builder: (context) {
//                if (state is EmptyState) {
//                  return Center(child: Text("无项目"));
//                }
//                if (state is LoadedState) {
//                  int index = 1;
//                  List<ListTile> lists =
//                      state.detailList.map<ListTile>((Detail detail) {
//                    return ListTile(
//                        leading: ExcludeSemantics(
//                            child: CircleAvatar(child: Text("${index++}"))),
//                        title: Text(detail.name),
//                        subtitle: Column(
//                          crossAxisAlignment: CrossAxisAlignment.stretch,
//                          children: <Widget>[
//                            Text('类型 ${detail.category}'),
//                            Text('数量 ${detail.count}'),
//                            Text('厂家 ${detail.odm}'),
//                            Text('备注 ${detail.remark}'),
//                          ],
//                        ),
//                        onTap: () {
//                          Navigator.push(context, new MaterialPageRoute(
//                              builder: (BuildContext context) {
//                            return widget.canEdit?FlowInstanceManager(
//                              detail: detail,
//                            ):FlowManager(
//                              detail: detail,
//                              userRepository: widget.userRepository,
//                            );
//                          }));
//                        },
//                        trailing: widget.canEdit
//                            ? Container(
//                                child: PopupMenuButton(
//                                  itemBuilder: (BuildContext context) =>
//                                      <PopupMenuItem<String>>[
//                                    PopupMenuItem<String>(
//                                      value: "modify",
//                                      child: Row(
//                                        mainAxisAlignment:
//                                            MainAxisAlignment.start,
//                                        crossAxisAlignment:
//                                            CrossAxisAlignment.center,
//                                        children: <Widget>[
//                                          Icon(
//                                            Icons.mode_edit,
//                                            color:
//                                                Theme.of(context).accentColor,
//                                          ),
//                                          Container(
//                                            margin: const EdgeInsets.all(10),
//                                            child: Text('修改'),
//                                          )
//                                        ],
//                                      ),
//                                    ),
//                                    PopupMenuItem<String>(
//                                      value: "remove",
//                                      child: Row(
//                                        mainAxisAlignment:
//                                            MainAxisAlignment.start,
//                                        crossAxisAlignment:
//                                            CrossAxisAlignment.center,
//                                        children: <Widget>[
//                                          Icon(
//                                            Icons.delete_forever,
//                                            color: Colors.red,
//                                          ),
//                                          Container(
//                                            margin: const EdgeInsets.all(10),
//                                            child: Text('删除'),
//                                          )
//                                        ],
//                                      ),
//                                    ),
//                                  ],
//                                  onSelected: (String result) {
//                                    if (result.compareTo("modify") == 0) {
//                                      Navigator.push(context,
//                                          MaterialPageRoute<bool>(
//                                              builder: (context) {
//                                        return ProjectDetailAddEditPage(
//                                          detailRepository: _detailRepository,
//                                          type: ProjectDetailAddEditPageType
//                                              .MODIFY,
//                                          detail: detail,
//                                          project: widget.project,
//                                        );
//                                      })).then((value) {
//
//                                      });
//                                    } else if (result.compareTo("remove") ==
//                                        0) {
//                                      DialogUtil.show(context,
//                                          content: Text("确定要删除?"), onPositive: () {
//                                        _detailManagerBloc.dispatch(
//                                            DeleteDetailEvent(detail: detail));
//                                      }, onNegative: () {});
//                                    }
//                                  },
//                                ),
//                              )
//                            : MaterialButton(
//                                child: Column(
//                                  mainAxisAlignment: MainAxisAlignment.start,
//                                  crossAxisAlignment: CrossAxisAlignment.center,
//                                  children: <Widget>[
//                                    Icon(
//                                      Icons.insert_chart,
//                                      color: Colors.green,
//                                    ),
//                                    Text("进度查看"),
//                                  ],
//                                ),
//                                onPressed: () {
//                                  Navigator.push(context, new MaterialPageRoute(
//                                      builder: (BuildContext context) {
//                                    return new ProgressStatus(
//                                      detail: detail,
//                                    );
//                                  }));
//                                }));
//                  }).toList();
////                return ListView.builder(itemBuilder: (context,position){
////                    return ListTile();
////                },itemCount: state.project.detail.length,);
//                  ListTile.divideTiles(context: context, tiles: lists);
//                  return ListView(
//                    children: lists,
//                  );
//                }
//
//                if (state is LoadingState) {
//                  return Center(child: CircularProgressIndicator());
//                }
//
//                return Container();
//              });
//            }),
//      ),
//    );
//  }
//}
