import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/beans/http_response.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/bloc/flow_instance_process_bloc.dart';
import 'package:manufacture/common/common.dart';
import 'package:manufacture/data/repository/flow_history_repository.dart';
import 'package:manufacture/data/repository/flow_nodes_repository.dart';
import 'package:manufacture/data/repository/flow_repository.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:manufacture/ui/pages/tech_page.dart';
import 'package:manufacture/ui/pages/tech_report_page.dart';
import 'package:manufacture/ui/pages/test_report_page.dart';
import 'package:manufacture/ui/widget/railway/railway.dart';
import 'package:manufacture/ui/widget/smart_filter_page/smart_filter_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:manufacture/ui/widget/timeline/model/timeline_model.dart';
import 'package:manufacture/ui/widget/timeline/timeline.dart';
import 'package:manufacture/ui/charts/pie_chart.dart';
import 'package:manufacture/util/dialog_util.dart';
import 'package:manufacture/util/snackbar_util.dart';
import 'flow_history_detail_page.dart';
import 'flow_join_page.dart';
import 'flow_reset_page.dart';
import '../../core/object_manager_page.dart';
import 'package:manufacture/beans/base_bean.dart';

import 'scan_page.dart';

class FlowInstanceProcess extends StatefulWidget {
  final FlowInstance instance;
  final FlowInstanceObjectRepository flowInstanceObjectRepository;
  FlowInstanceProcess(
      {@required this.instance, @required this.flowInstanceObjectRepository})
      : assert(instance != null);
  @override
  State<StatefulWidget> createState() => _FlowInstanceProcessState();
}

class _FlowInstanceProcessState extends State<FlowInstanceProcess> {
  FlowInstanceProcessBloc _flowInstanceProcessBloc;
  FlowHistoryObjectRepository _flowHistoryObjectRepository;
  FlowRepository _flowRepository;
  final StreamController<FlowInstance> _streamController =
      StreamController(sync: false);
  ObjectManagerController _objectManagerController =
      ObjectManagerController("refresh");

  _getFlowInstance() async {
    FlowInstance instance =
        await widget.flowInstanceObjectRepository.get(widget.instance.id);
    print("1111 $instance");
    _streamController.sink.add(instance);
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  @override
  void initState() {
    _flowRepository = new FlowRepository();
    _flowHistoryObjectRepository = FlowHistoryObjectRepository.init();
    _flowInstanceProcessBloc = FlowInstanceProcessBloc(
        flowNodesRepository: FlowNodesRepository(),
        flowInstanceObjectRepository: widget.flowInstanceObjectRepository);
    _flowInstanceProcessBloc.add(StartEvent(instance: widget.instance));
    _streamController.sink.add(widget.instance);
    //_getOrderNodes();
    super.initState();
  }

  @override
  void dispose() {
    _flowInstanceProcessBloc.close();
    _streamController.close();
    super.dispose();
  }

  Widget _buildLine(bool visible) {
    return Container(
      width: visible ? 1.0 : 0.0,
      height: 10,
      color: Theme.of(context).accentColor,
    );
  }

  Widget _buildCircle() {
    return Container(
      //margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: 10,
      height: 10,
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  FlowHistory _getHistory(List<FlowHistory> list, Node node) {
    for (FlowHistory history in list) {
      if (history.node == node.id) {
        return history;
      }
    }
    return null;
  }

  bool _isCurrent(FlowInstance flowInstance, Node node) {
    return flowInstance.current_node == node.id ? true : false;
  }

  int _getFinished(List<FlowHistory> historyList) {
    int finished = 0;
    for (FlowHistory history in historyList) {
      if (history.status.compareTo("已完成") == 0) {
        finished += 1;
      }
    }
    return finished;
  }

  PopupMenuItem _skipNodeMenuItem(FlowInstance instance, Node node) {
    return PopupMenuItem(
      child: ListTile(
        leading: Icon(Icons.redo),
        title: Text("跳过"),
        dense: true,
        onTap: () {
          Navigator.pop(context);
          DialogUtil.show(context, content: Text("确定要跳过?"), onPositive: () {
            _flowInstanceProcessBloc
                .add(SkipEvent(instance: instance, node: node));
          });
        },
      ),
    );
  }

  PopupMenuItem _resetSingleNodeMenuItem(FlowInstance instance, Node node) {
    return PopupMenuItem(
      child: ListTile(
        leading: Icon(Icons.redo),
        title: Text("重置"),
        dense: true,
        onTap: () {
          Navigator.pop(context);
          DialogUtil.show(context, content: Text("确定要重置?"), onPositive: () {
            _flowInstanceProcessBloc
                .add(ResetSingleNodeEvent(instance: instance, node: node));
          });
        },
      ),
    );
  }

  PopupMenuItem _confirmMenuItem(FlowInstance instance, Node node) {
    return PopupMenuItem(
      child: ListTile(
        leading: Icon(Icons.redo),
        title: Text("审核"),
        dense: true,
        onTap: () {
          Navigator.pop(context);
          DialogUtil.show(context, content: Text("确定要审核?"), onPositive: () {
            _flowInstanceProcessBloc
                .add(ConfirmEvent(instance: instance, node: node));
          });
        },
      ),
    );
  }

  void _resetNodes(List<Node> orderedNodeList, FlowInstance instance) {
    Navigator.push<Node>(context,
        new MaterialPageRoute(builder: (BuildContext context) {
      return new FlowReset(nodeList: orderedNodeList);
    })).then((Node node) {
      if (node != null)
        _flowInstanceProcessBloc
            .add(ResetNodesEvent(instance: instance, node: node));
      //处理代码
    });
  }

  void confirm() {}

  Station _buildFinishedStation(
      FlowHistory history, Node node, FlowInstance instance) {
    // 如果不等于已完成，颜色为黄色
    Color color;

    if (history.status.compareTo("已完成") == 0) {
      color = Theme.of(context).accentColor;
    } else {
      color = Colors.amber;
    }

    List<PopupMenuItem> popUpMenuItemList = [];

    //popUpMenuItemList.add(_resetSingleNodeMenuItem(instance, node),);

    if (history != null) {
      //if (history.status.compareTo("待审核") == 0) {
      popUpMenuItemList.add(_resetSingleNodeMenuItem(instance, node));
      if (history.status.compareTo("待审核") == 0) {
        popUpMenuItemList.add(_confirmMenuItem(instance, node));
      }
    }
    DateTime _date = DateTime.parse(history.check_at).toLocal();

    return Station(
      title: node.name,
      color: color,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            leading: Text("状态"),
            title: Text(history != null ? history.status : "无"),
            dense: true,
            trailing: IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () async {
                if (node.node_type == Common.nodeTypeTest) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return TestReportPage(
                      flowHistory: history,
                    );
                  }));
                } else if (node.node_type == Common.nodeTypeTech) {
                  if (history != null && history.status.compareTo("待创建") == 0) {
                    if (node.out_flow) {
                      await Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) {
                        return new FlowJoin(
                          flowCode: instance.code,
                          nodeCode: node.code,
                          flowRepository: widget.flowInstanceObjectRepository,
                        );
                      })).then((response) {
                        if (response == null) return;
                        ReqResponse hr = response as ReqResponse;
                        print(hr);
                        if (hr.isSuccess) {
                          SnackBarUtil.success(
                              context: context, message: hr.message);
                        } else {
                          SnackBarUtil.fail(
                              context: context, message: hr.message);
                        }

                      });

                    } else {
                      await Navigator.push(context, new MaterialPageRoute(
                          builder: (BuildContext context) {
                        return new Tech(
                          flowInstance: instance,
                          node: node,
                        );
                      }));
                    }
                    _objectManagerController.requestRefresh();
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TechReportPage(
                        techId: history.work_pk,
                        node: node,
                      );
                    }));
                  }
                }
              },
            ),
          ),
          ListTile(
              leading: Text("操作"),
              title: Text(history != null ? history.check_by : "无"),
              dense: true),
          ListTile(
              leading: Text("时间"),
              title: Text(history != null
                  ? "${_date.year}-${_twoDigits(_date.month)}-${_twoDigits(_date.day)}T${_twoDigits(_date.hour)}:${_twoDigits(_date.minute)}:00+08:00"
                  : "无"),
              dense: true),
        ],
      ),
      actionBuilder: (context, index) {
        return PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
            color: color,
          ),
          itemBuilder: (context) => popUpMenuItemList,
        );
      },
    );
  }

  Station _buildCurrentStation(
      FlowHistory history, Node node, FlowInstance instance) {
    if (history != null) {
      if (history.status.compareTo("已完成") == 0) {
        return _buildFinishedStation(history, node, instance);
      }
    }

    List<PopupMenuItem> popUpMenuItemList = [];

    if (history != null) {
      //if (history.status.compareTo("待审核") == 0) {
      popUpMenuItemList.add(_resetSingleNodeMenuItem(instance, node));
      if (history.status.compareTo("待审核") == 0) {
        popUpMenuItemList.add(_confirmMenuItem(instance, node));
      }
    } else {
      popUpMenuItemList.add(_skipNodeMenuItem(instance, node));
    }

    return Station(
      color: Theme.of(context).accentColor,
      title: node.name,
      customIcon: Icon(
        Icons.directions_run,
        size: 30,
        color: Theme.of(context).accentColor,
      ),
      content: Builder(
        builder: (context) {
          return ListTile(
            leading: Text("状态"),
            title: history != null ? Text(history.status) : Text("当前"),
            dense: true,
            trailing: IconButton(
              icon: Icon(
                Icons.chevron_right,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () async {
                if (history != null && history.status.compareTo("待审核") == 0) {
                  if (node.node_type == Common.nodeTypeTest) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TestReportPage(
                        flowHistory: history,
                      );
                    }));
                  } else if (node.node_type == Common.nodeTypeTech) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TechReportPage(
                        techId: history.work_pk,
                        node: node,
                      );
                    }));
                  }
                  return;
                }

                if (node.out_flow) {
                  await Navigator.push(context,
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return new FlowJoin(
                      flowCode: instance.code,
                      nodeCode: node.code,
                      flowRepository: widget.flowInstanceObjectRepository,
                    );
                  })).then((response) {
                    if (response == null) return;
                    ReqResponse hr = response as ReqResponse;
                    print(hr);
                    if (hr.isSuccess) {
                      SnackBarUtil.success(
                          context: context, message: hr.message);
                    } else {
                      SnackBarUtil.fail(context: context, message: hr.message);
                    }
                    _objectManagerController.requestRefresh();
                  });
                } else if (node.node_type == Common.nodeTypeTech) {
                  await Navigator.push(context,
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return new Tech(
                      flowInstance: instance,
                      node: node,
                    );
                  }));
                  _objectManagerController.requestRefresh();
                } else {
                  DialogUtil.alert(
                    context,
                    content: Text("请在pc上操作"),
                  );
                }
              },
            ),
          );
        },
      ),
      actionBuilder: (context, index) {
        return PopupMenuButton(
          icon: Icon(
            Icons.more_vert,
            color: Theme.of(context).accentColor,
          ),
          itemBuilder: (context) => popUpMenuItemList,
        );
      },
    );
  }

  Station _buildTobeDoneStation(
      FlowHistory history, Node node, FlowInstance instance) {
    return Station(
      color: Colors.grey,
      title: node.name,
      actionBuilder: (context, index) {
        return PopupMenuButton(
          enabled: false,
          icon: Icon(
            Icons.more_vert,
            color: Colors.grey,
          ),
          itemBuilder: (context) {
            return <PopupMenuItem>[];
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("流程管理"),
      ),
      body: BlocListener<FlowInstanceProcessBloc, FlowInstanceProcessState>(
        bloc: _flowInstanceProcessBloc,
        listener: (context, state) {
          if (state is DoneState) {
            if (state.isSuccess) {
              _objectManagerController.requestRefresh();
            }
            SnackBarUtil.show(
                context: context,
                message: state.message,
                isSuccess: state.isSuccess);
            //_objectManagerController.requestRefresh();
          }
        },
        child: BlocBuilder<FlowInstanceProcessBloc, FlowInstanceProcessState>(
          bloc: _flowInstanceProcessBloc,
          condition: (previousState, currentState) {
            if (currentState is LoadedState) {
              return true;
            } else {
              return false;
            }
          },
          builder: (context, state) {
            if (state is LoadedState) {
              return ObjectManagerPage<FlowHistory>.custom(
                title: "流程管理",
                enablePullUp: false,
                objectManagerController: _objectManagerController,
                objectRepository: _flowHistoryObjectRepository,
                initQueryParams: {"instance": widget.instance.id},
                customWidgetBuilder: (context, List<BaseBean> list) {
                  _getFlowInstance();
                  return StreamBuilder<FlowInstance>(
                    stream: _streamController.stream,
                    builder: (context, snapshort) {
                      if (snapshort.data == null) {
                        return CircularProgressIndicator();
                      }

                      List<Widget> _silverList = [];
                      _silverList.add(Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              color: Colors.grey[100],
                              height: 16,
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.info,
                                color: Theme.of(context).accentColor,
                              ),
                              dense: true,
                              title: Text("基本信息"),
                            ),
                            ListTile(
                              leading: Text("编号"),
                              dense: true,
                              title: Text(snapshort.data.code),
                            ),
                            ListTile(
                              leading: Text("状态"),
                              dense: true,
                              title: Text(snapshort.data.status),
                            ),
                            Container(
                              color: Colors.grey[100],
                              height: 16,
                            ),
                          ],
                        ),
                      ));

                      _silverList.add(Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.device_unknown,
                                color: Theme.of(context).accentColor,
                              ),
                              dense: true,
                              title: Text("绑定信息"),
                            ),
                            ListTile(
                              dense: true,
                              leading:
                                  Text('产品信息', style: TextStyle(fontSize: 14)),
                              title: Text(
                                  snapshort.data.product_code != null
                                      ? snapshort.data.product_code
                                      : "未绑定",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.green)),
                              trailing: snapshort.data.product_code != null
                                  ? MaterialButton(
                                      child: Text(
                                        "解绑",
                                      ),
                                      color: Colors.red,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          side: BorderSide(
                                              color: Color(0xFFFFF00F),
                                              style: BorderStyle.solid,
                                              width: 0)),
                                      onPressed: () {
                                        showDialog(
                                            builder: (context) =>
                                                new AlertDialog(
                                                  title: new Text('提示'),
                                                  content: new Text('确定要解除绑定？'),
                                                  actions: <Widget>[
                                                    new FlatButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          _flowInstanceProcessBloc.add(
                                                              UnBindProductEvent(
                                                                  instance:
                                                                      snapshort
                                                                          .data));
                                                        },
                                                        child: new Text('确定')),
                                                    new FlatButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: new Text('取消'))
                                                  ],
                                                ),
                                            context: context);
                                      },
                                    )
                                  : MaterialButton(
                                      child: Text(
                                        "绑定",
                                      ),
                                      color: Colors.green,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          side: BorderSide(
                                              color: Color(0xFFFFF00F),
                                              style: BorderStyle.solid,
                                              width: 0)),
                                      onPressed: () {
                                        Navigator.push<String>(context,
                                            new MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return new Scan(title: "录入产品编号");
                                        })).then((String result) {
                                          //TODO:添加产品编号
                                          if (result != null) {
                                            _flowInstanceProcessBloc.add(
                                                BindProductEvent(
                                                    instance: snapshort.data,
                                                    productCode: result));
                                          }
                                        });
                                      },
                                    ),
                            ),
                            Container(
                              color: Colors.grey[100],
                              height: 16,
                            ),
                          ],
                        ),
                      ));

                      _silverList.add(Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                Icons.pie_chart,
                                color: Theme.of(context).accentColor,
                              ),
                              dense: true,
                              title: Text("进度信息"),
                            ),
                            Container(
                              height: 300,
                              child: Container(
                                margin: EdgeInsets.all(10),
                                child: PieCharts(
                                  pieNegative: PieNegative(
                                      name: "未完成",
                                      count: state.orderNodeList.length -
                                          _getFinished(
                                              list as List<FlowHistory>),
                                      color: Colors.red),
                                  piePositive: PiePositive(
                                      name: "已完成",
                                      count: _getFinished(
                                          list as List<FlowHistory>),
                                      color: Colors.green),
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.grey[100],
                              height: 16,
                            ),
                          ],
                        ),
                      ));

                      _silverList.add(Container(
                          color: Colors.white,
                          child: ListTile(
                            leading: Icon(
                              Icons.list,
                              color: Theme.of(context).accentColor,
                            ),
                            dense: true,
                            title: Text("流程信息"),
                            trailing: FlatButton(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Icon(
                                    Icons.autorenew,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  Text("重置流程"),
                                ],
                              ),
                              onPressed: () {
                                _resetNodes(
                                    state.orderNodeList, snapshort.data);
                              },
                            ),
                          )));

                      _silverList.add(Container(
                        color: Colors.white,
                        child: RailWay(
                            physics: NeverScrollableScrollPhysics(),
                            stations: state.orderNodeList.map((node) {
                              FlowHistory _history = _getHistory(
                                  (list as List<FlowHistory>), node);
                              if (_isCurrent(snapshort.data, node)) {
                                return _buildCurrentStation(
                                    _history, node, snapshort.data);
                              } else if (_history != null) {
                                return _buildFinishedStation(
                                    _history, node, snapshort.data);
                              } else {
                                return _buildTobeDoneStation(
                                    _history, node, snapshort.data);
                              }
                            }).toList()),
                      ));

                      _silverList.add(
                        Container(
                          color: Colors.grey[100],
                          height: 50,
                        ),
                      );

                      return ListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: _silverList,
                      );
                    },
                  );
                },
              );
//              _getFlowInstance();
//              return StreamBuilder<FlowInstance>(
//                stream: _streamController.stream,
//                builder: (context, AsyncSnapshot snapshot){
//                  if(snapshot.data == null){
//                    return CircularProgressIndicator();
//                  }else{
//                    return ObjectManagerPage<FlowHistory>.custom(
//                      title: "流程管理",
//                      enablePullUp: false,
//                      objectManagerController: _objectManagerController,
//                      objectRepository: _flowHistoryObjectRepository,
//                      initQueryParams: {"instance": (snapshot.data as FlowInstance).id},
//                      customWidgetBuilder: (context, List<BaseBean> list) {
//                        List<Widget> _silverList = [];
//                        //builder header
//                        _silverList.add(Container(
//                          color: Colors.white,
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            crossAxisAlignment: CrossAxisAlignment.stretch,
//                            children: <Widget>[
//                              Container(
//                                color: Colors.grey[100],
//                                height: 16,
//                              ),
//                              ListTile(
//                                leading: Icon(
//                                  Icons.info,
//                                  color: Theme.of(context).accentColor,
//                                ),
//                                dense: true,
//                                title: Text("基本信息"),
//                              ),
//                              ListTile(
//                                leading: Text("编号"),
//                                dense: true,
//                                title: Text("${(snapshot.data as FlowInstance).code}"),
//                              ),
//                              ListTile(
//                                leading: Text("状态"),
//                                dense: true,
//                                title: Text("${(snapshot.data as FlowInstance).status}"),
//                              ),
//                              Container(
//                                color: Colors.grey[100],
//                                height: 16,
//                              ),
//                            ],
//                          ),
//                        ));
//
//                        _silverList.add(Container(
//                          color: Colors.white,
//                          child: Column(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            crossAxisAlignment: CrossAxisAlignment.stretch,
//                            children: <Widget>[
//                              ListTile(
//                                leading: Icon(
//                                  Icons.pie_chart,
//                                  color: Theme.of(context).accentColor,
//                                ),
//                                dense: true,
//                                title: Text("进度信息"),
//                              ),
//                              Container(
//                                height: 300,
//                                child: Container(
//                                  margin: EdgeInsets.all(10),
//                                  child: PieCharts(
//                                    pieNegative: PieNegative(
//                                        name: "未完成",
//                                        count: state.orderNodeList.length -
//                                            _getFinished(list as List<FlowHistory>),
//                                        color: Colors.red),
//                                    piePositive: PiePositive(
//                                        name: "已完成",
//                                        count: _getFinished(list as List<FlowHistory>),
//                                        color: Colors.green),
//                                  ),
//                                ),
//                              ),
//                              Container(
//                                color: Colors.grey[100],
//                                height: 16,
//                              ),
//                            ],
//                          ),
//                        ));
//
//                        _silverList.add(Container(
//                            color: Colors.white,
//                            child: ListTile(
//                              leading: Icon(
//                                Icons.list,
//                                color: Theme.of(context).accentColor,
//                              ),
//                              dense: true,
//                              title: Text("流程信息"),
//                              trailing: FlatButton(
//                                child: Row(
//                                  mainAxisSize: MainAxisSize.min,
//                                  children: <Widget>[
//                                    Icon(Icons.autorenew,color: Theme.of(context).accentColor,),
//                                    Text("重置"),
//                                  ],
//                                ),
//                                onPressed: (){
//                                  _resetNodes(state.orderNodeList, (snapshot.data as FlowInstance));
//                                },
//                              ),
//                            )));
//
//                        _silverList.add(Container(
//                          color: Colors.white,
//                          child: RailWay(
//                              physics: NeverScrollableScrollPhysics(),
//                              stations: state.orderNodeList.map((node) {
//                                FlowHistory _history =
//                                _getHistory((list as List<FlowHistory>), node);
//                                if (_isCurrent((snapshot.data as FlowInstance), node)) {
//                                  return _buildCurrentStation(
//                                      _history, node, (snapshot.data as FlowInstance));
//                                } else if (_history != null) {
//                                  return _buildFinishedStation(
//                                      _history, node, (snapshot.data as FlowInstance));
//                                } else {
//                                  return _buildTobeDoneStation(
//                                      _history, node, (snapshot.data as FlowInstance));
//                                }
//                              }).toList()),
//                        ));
//
//                        _silverList.add(
//                          Container(
//                            color: Colors.grey[100],
//                            height: 50,
//                          ),
//                        );
//
//                        return ListView(
//                          shrinkWrap: true,
//                          physics: NeverScrollableScrollPhysics(),
//                          children: _silverList,
//                        );
//                      },
//                    );
//                  }
//                },
//              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
//    return Scaffold(
//      body: StreamBuilder<List<Node>>(
//        stream: _streamController.stream,
//        builder: (context, AsyncSnapshot snapshot) {
//          if (snapshot.data == null) {
//            return Center(
//              child: CircularProgressIndicator(),
//            );
//          } else {
//            return ObjectManagerPage<FlowHistory>.custom(
//              title: "流程管理",
//              enablePullUp: false,
//              objectManagerController: _objectManagerController,
//              objectRepository: _flowHistoryObjectRepository,
//              initQueryParams: {"instance": widget.instance.id},
//              customWidgetBuilder: (context, List<BaseBean> list) {
//                List<Widget> _silverList = [];
//                //builder header
//                _silverList.add(Container(
//                  color: Colors.white,
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    crossAxisAlignment: CrossAxisAlignment.stretch,
//                    children: <Widget>[
//                      Container(
//                        color: Colors.grey[100],
//                        height: 16,
//                      ),
//                      ListTile(
//                        leading: Icon(
//                          Icons.info,
//                          color: Theme.of(context).accentColor,
//                        ),
//                        dense: true,
//                        title: Text("基本信息"),
//                      ),
//                      ListTile(
//                        leading: Text("编号"),
//                        dense: true,
//                        title: Text("${widget.instance.code}"),
//                      ),
//                      ListTile(
//                        leading: Text("状态"),
//                        dense: true,
//                        title: Text("${widget.instance.status}"),
//                      ),
//                      Container(
//                        color: Colors.grey[100],
//                        height: 16,
//                      ),
//                    ],
//                  ),
//                ));
//
//                _silverList.add(Container(
//                  color: Colors.white,
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    crossAxisAlignment: CrossAxisAlignment.stretch,
//                    children: <Widget>[
//                      ListTile(
//                        leading: Icon(
//                          Icons.pie_chart,
//                          color: Theme.of(context).accentColor,
//                        ),
//                        dense: true,
//                        title: Text("进度信息"),
//                      ),
//                      Container(
//                        height: 300,
//                        child: Container(
//                          margin: EdgeInsets.all(10),
//                          child: PieCharts(
//                            pieNegative: PieNegative(
//                                name: "未完成",
//                                count: (snapshot.data as List<Node>).length -
//                                    _getFinished(list as List<FlowHistory>),
//                                color: Colors.red),
//                            piePositive: PiePositive(
//                                name: "已完成",
//                                count: _getFinished(list as List<FlowHistory>),
//                                color: Colors.green),
//                          ),
//                        ),
//                      ),
//                      Container(
//                        color: Colors.grey[100],
//                        height: 16,
//                      ),
//                    ],
//                  ),
//                ));
//
//                _silverList.add(Container(
//                    color: Colors.white,
//                    child: ListTile(
//                      leading: Icon(
//                        Icons.list,
//                        color: Theme.of(context).accentColor,
//                      ),
//                      dense: true,
//                      title: Text("流程信息"),
//                    )));
//
//                _silverList.add(Container(
//                  color: Colors.white,
//                  child: RailWay(
//                      physics: NeverScrollableScrollPhysics(),
//                      stations: (snapshot.data as List<Node>).map((node) {
//                        FlowHistory _history =
//                            _getHistory((list as List<FlowHistory>), node);
//                        if (_isCurrent(widget.instance, node)) {
//                          return _buildCurrentStation(
//                              _history, node, widget.instance);
//                        } else if (_history != null) {
//                          return _buildFinishedStation(
//                              _history, node, widget.instance);
//                        } else {
//                          return _buildTobeDoneStation(
//                              _history, node, widget.instance);
//                        }
//                      }).toList()),
//                ));
//
//                _silverList.add(
//                  Container(
//                    color: Colors.grey[100],
//                    height: 50,
//                  ),
//                );
//
//                return ListView(
//                  shrinkWrap: true,
//                  physics: NeverScrollableScrollPhysics(),
//                  children: _silverList,
//                );
//              },
//            );
//          }
//        },
//      ),
//    );
  }
}
