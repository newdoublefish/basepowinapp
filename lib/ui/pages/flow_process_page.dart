import 'package:flutter/material.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/bloc/flow_query_bloc.dart';
import 'package:manufacture/data/repository/project_respository.dart';
import 'package:manufacture/data/repository/flow_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/ui/widget/timeline/model/timeline_model.dart';
import 'package:manufacture/ui/widget/timeline/timeline.dart';
import 'package:manufacture/util/snackbar_util.dart';
import "tech_page.dart";
import 'review_page.dart';
import 'dart:async';
import 'package:manufacture/common/common.dart';
import 'flow_join_page.dart';
import 'ship_query_page.dart';
import 'flow_reset_page.dart';
import 'flow_history_detail_page.dart';
import 'scan_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:manufacture/data/repository/user_repository.dart';
import 'package:manufacture/beans/http_response.dart';
import 'package:manufacture/data/repository/flow_nodes_repository.dart';

enum FlowSearchTypeEnum { flow, product }

class FlowProcessPage extends StatefulWidget {
  final String code;
  final FlowSearchTypeEnum type;
  final bool canOperate;
  final UserRepository userRepository;
  final FlowNodesRepository flowNodesRepository;
  FlowProcessPage(
      {Key key,
      this.code,
      @required this.userRepository,
      this.type = FlowSearchTypeEnum.flow,
        this.flowNodesRepository,
      this.canOperate = true})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => ProductDetailPageState();
}

class ProductDetailPageState extends State<FlowProcessPage> {
  FlowQueryBloc _flowQueryBloc;
  FlowRepository _flowRepository;
  final double _textSize = 14;

  @override
  void initState() {
    // TODO: implement initState
    _flowRepository = new FlowRepository();
    _flowQueryBloc = FlowQueryBloc(flowRepository: _flowRepository,flowNodesRepository: widget.flowNodesRepository);
    if (widget.type == FlowSearchTypeEnum.product) {
      _flowQueryBloc
          .add(FetchFlowQueryEventByProductCode(productCode: widget.code));
    } else {
      _flowQueryBloc.add(
          FetchFlowQueryEventByFlowCode(flowInstanceText: widget.code));
    }
    super.initState();
  }

  @override
  void dispose() {
    _flowQueryBloc.close();
    super.dispose();
  }

  void onClickTimeLine(TimelineModel model) {
    print(model.title);
  }

  FlowHistory _getFlowHistory(int nodeId, List<FlowHistory> flowList) {
    for (FlowHistory history in flowList) {
      if (history.node == nodeId) {
        return history;
      }
    }
    return null;
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _showDialog() {
    showDialog(
        builder: (context) => new AlertDialog(
              title: new Text('提示'),
              content: new Text('请在测试软件上操作该工序'),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Text('确定'))
              ],
            ),
        context: context);
  }

  String _getFlowStatus(int code) {
    String ret;
    switch (code) {
      case 0:
        ret = '未开始';
        break;
      case 1:
        ret = "进行中";
        break;
      case 2:
        ret = "已结束";
        break;
    }
    return ret;
  }

  Color _showNodeStatusColor(FlowHistory history) {
    if (history == null) {
      return Colors.grey;
    }
    if (history.status.compareTo("已完成") == 0) {
      return Colors.green;
    } else if (history.status.compareTo("已跳过") == 0) {
      return Colors.deepOrange[400];
    } else if (history.status.compareTo("待审核") == 0) {
      return Colors.blue[400];
    } else {
      return Colors.grey;
    }
  }

  bool _isCurrent(FlowInstance flowInstance, Node node) {
    return flowInstance.current_node == node.id ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<FlowQueryBloc, FlowQueryState>(
      bloc: _flowQueryBloc,
      builder: (BuildContext context, FlowQueryState state) {
        print(state);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '流水详情',
            ),
            actions: <Widget>[
              widget.userRepository.authority.can_reset_total
                  ? IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        {
                          if (_flowQueryBloc.orderedList != null) {
                            Navigator.push<Node>(context, new MaterialPageRoute(
                                builder: (BuildContext context) {
                              return new FlowReset(
                                  nodeList: _flowQueryBloc.orderedList);
                            })).then((Node node) {
                              if (node != null)
                                _flowQueryBloc
                                    .add(RestInstanceEvent(node: node));
                              //处理代码
                            });
                          }
                        }
                      })
                  : Container(),
            ],
          ),
          body: Builder(builder: (context) {
            if (state is FlowQuerySuccess) {
              _onWidgetDidBuild(() {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${state.msg}'),
                    backgroundColor: state.success ? Colors.green : Colors.red,
                  ),
                );
              });
            }

            if (state is FlowQueryLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is FlowQueryLoaded) {
              return Container(
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.info,
                                    color: Colors.green,
                                  ),
                                  Text('  基本信息')
                                ],
                              ),
                            ),
                            ListTile(
                              dense: true,
                              leading: Text(
                                '流水编号',
                                style: TextStyle(fontSize: _textSize),
                              ),
                              title: Text(state.flowInstance.code,
                                  style: TextStyle(fontSize: _textSize)),
                            ),
                            ListTile(
                              dense: true,
                              leading: Text('产品信息',
                                  style: TextStyle(fontSize: _textSize)),
                              title: Text(
                                  state.flowInstance.product_code != null
                                      ? state.flowInstance.product_code
                                      : "未绑定",
                                  style: TextStyle(
                                      fontSize: _textSize,
                                      color: Colors.green)),
                              trailing: widget
                                      .userRepository.authority.can_operate
                                  ? state.flowInstance.product_code != null
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
                                                      content:
                                                          new Text('确定要解除绑定？'),
                                                      actions: <Widget>[
                                                        new FlatButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              _flowQueryBloc.add(
                                                                  UnBindProductEvent(
                                                                      flowInstanceText:
                                                                          widget
                                                                              .code));
                                                            },
                                                            child:
                                                                new Text('确定')),
                                                        new FlatButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                new Text('取消'))
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
                                                _flowQueryBloc.add(
                                                    BindProductEvent(
                                                        flowInstanceText:
                                                            widget.code,
                                                        productCode: result));
                                              }
                                            });
                                          },
                                        )
                                  : null,
                            ),
                            ListTile(
                              dense: true,
                              leading: Text('状态',
                                  style: TextStyle(fontSize: _textSize)),
                              title: Text(
                                  //getFlowStatus(state.flowInstance.status),
                                  state.flowInstance.status,
                                  style: TextStyle(fontSize: _textSize)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.dialpad,
                                    color: Colors.green,
                                  ),
                                  Text('  流程信息')
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      TimelineComponent(
                        timelineList:
                            state.nodeList.map<TimelineModel>((Node node) {
                          //print(node);
                          FlowHistory history =
                              _getFlowHistory(node.id, state.flowHistoryList);
                          if (history == null) {
                            //可能是当前点，也可能是未测试点
                            if (_isCurrent(state.flowInstance, node)) {
                              return TimelineModel(
                                  title: node.name,
                                  titleColor: _showNodeStatusColor(history),
                                  description: "当前",
                                  isCurrent:
                                      _isCurrent(state.flowInstance, node),
                                  onPressed: () async {
                                    if (node.out_flow == true) {
                                      //_onWidgetDidBuild(_showDialog);
                                      await Navigator.push(context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) {
//                                        return new FlowJoin(
//                                          flowCode: state.flowInstance.code,
//                                          nodeCode: node.code,
//                                          flowRepository: _flowRepository,
//                                        );
                                              return null;
                                      })).then((response) {
                                        if(response == null) return;
                                        HttpResponse hr =
                                            response as HttpResponse;
                                        if (hr == null ||
                                            hr.status.compareTo("error") == 0) {
                                          SnackBarUtil.fail(
                                              context: context,
                                              message: hr.message);
                                        } else {
                                          SnackBarUtil.success(
                                              context: context,
                                              message: hr.message);

                                          _flowQueryBloc.add(
                                              FetchFlowInstanceRefreshEvent(
                                                  flowInstanceText:
                                                      widget.code));
                                        }
                                        return;
                                      });
                                    } else if (node.node_type ==
                                        Common.nodeTypeTech) {
                                      await Navigator.push(context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return new Tech(
                                          flowInstance: state.flowInstance,
                                          node: node,
                                        );
                                      }));
                                      _flowQueryBloc.add(
                                          FetchFlowInstanceRefreshEvent(
                                              flowInstanceText: widget.code));
                                    } else if (node.node_type ==
                                        Common.nodeTypeTest) {
                                      _showDialog();
                                      _flowQueryBloc.add(
                                          FetchFlowInstanceRefreshEvent(
                                              flowInstanceText: widget.code));
                                    }



                                  },
                                  customWidget: history == null
                                      ? node.can_skip
                                          ? Builder(builder: (context) {
                                              return Slidable(
                                                key: new Key(node.code),
                                                closeOnScroll: true,
                                                delegate:
                                                    new SlidableDrawerDelegate(),
                                                actionExtentRatio: 0.25,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: <Widget>[
                                                    Text(
                                                      '当前',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: MaterialButton(
                                                      //height: 20,
                                                      color: Colors.red,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          side: BorderSide(
                                                              color: Color(
                                                                  0xFFFFF00F),
                                                              style: BorderStyle
                                                                  .solid,
                                                              width: 0)),
                                                      child: Text('跳过'),
                                                      onPressed: () {
                                                        showDialog(
                                                            builder: (context) =>
                                                                new AlertDialog(
                                                                  title:
                                                                      new Text(
                                                                          '提示'),
                                                                  content: new Text(
                                                                      '确定要跳过？'),
                                                                  actions: <
                                                                      Widget>[
                                                                    new FlatButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          _flowQueryBloc.add(SkipNodeEvent(
                                                                              flowInstanceText: widget.code,
                                                                              nodeCode: node.code));
                                                                        },
                                                                        child: new Text(
                                                                            '确定')),
                                                                    new FlatButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: new Text(
                                                                            '取消'))
                                                                  ],
                                                                ),
                                                            context: context);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            })
                                          : null
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Text("状态:${history.status}"),
                                            Text(
                                                '时间:${history.getFormatTime()}'),
                                          ],
                                        ));
                            } else {
                              //未开始无法操作
                              return TimelineModel(
                                  title: node.name,
                                  isCurrent:
                                      _isCurrent(state.flowInstance, node),
                                  titleColor: _showNodeStatusColor(history),
                                  description: "未开始",
                                  onPressed: () {});
                            }
                          } else {
                            //各种点都有可能
                            if (history.status.compareTo("已完成") != 0 &&
                                history.status.compareTo("已跳过") != 0) {
                              return TimelineModel(
                                  title: node.name,
                                  titleColor: _showNodeStatusColor(history),
                                  description: "当前",
                                  isCurrent:
                                      _isCurrent(state.flowInstance, node),
                                  onPressed: () async {
                                    if (history.status.compareTo("待审核") == 0) {
                                      await Navigator.push(context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return new Review(
                                          flowCode: state.flowInstance.code,
                                          nodeCode: node.code,
                                          flowRepository: _flowRepository,
                                        );
                                      }));
                                    } else {
                                      if (node.out_flow == true) {
                                        //_onWidgetDidBuild(_showDialog);
                                        await Navigator.push(context,
                                            new MaterialPageRoute(builder:
                                                (BuildContext context) {
                                              return null;
//                                          return new FlowJoin(
//                                            flowCode: state.flowInstance.code,
//                                            nodeCode: node.code,
//                                            flowRepository: _flowRepository,
//                                          );
                                        })).then((response) {
                                          if (response == null) return;
                                          HttpResponse hr =
                                              response as HttpResponse;
                                          if (hr == null ||
                                              hr.status.compareTo("error") ==
                                                  0) {
                                            SnackBarUtil.fail(
                                                context: context,
                                                message: hr.message);
                                          } else {
                                            SnackBarUtil.success(
                                                context: context,
                                                message: hr.message);

                                            _flowQueryBloc.add(
                                                FetchFlowInstanceRefreshEvent(
                                                    flowInstanceText:
                                                        widget.code));
                                          }
                                        });
                                      } else if (node.node_type ==
                                          Common.nodeTypeTech) {
                                        await Navigator.push(context,
                                            new MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return new Tech(
                                            flowInstance: state.flowInstance,
                                            node: node,
                                          );
                                        }));
                                        _flowQueryBloc.add(
                                            FetchFlowInstanceRefreshEvent(
                                                flowInstanceText: widget.code));
                                      } else if (node.node_type ==
                                          Common.nodeTypeShip) {
                                        await Navigator.push(context,
                                            new MaterialPageRoute(builder:
                                                (BuildContext context) {
                                          return new ShipQuery(
                                            flowCode: state.flowInstance.code,
                                            nodeCode: node.code,
                                            flowRepository: _flowRepository,
                                          );
                                        }));
                                        _flowQueryBloc.add(
                                            FetchFlowInstanceRefreshEvent(
                                                flowInstanceText: widget.code));
                                      }
                                    }


                                  },
                                  customWidget: history == null
                                      ? node.can_skip
                                          ? Builder(builder: (context) {
                                              return Slidable(
                                                key: new Key(node.code),
                                                closeOnScroll: true,
                                                delegate:
                                                    new SlidableDrawerDelegate(),
                                                actionExtentRatio: 0.25,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: <Widget>[
                                                    Text(
                                                      '当前',
                                                      style: TextStyle(
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: MaterialButton(
                                                      //height: 20,
                                                      color: Colors.red,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                          side: BorderSide(
                                                              color: Color(
                                                                  0xFFFFF00F),
                                                              style: BorderStyle
                                                                  .solid,
                                                              width: 0)),
                                                      child: Text('跳过'),
                                                      onPressed: () {
                                                        showDialog(
                                                            builder: (context) =>
                                                                new AlertDialog(
                                                                  title:
                                                                      new Text(
                                                                          '提示'),
                                                                  content: new Text(
                                                                      '确定要跳过？'),
                                                                  actions: <
                                                                      Widget>[
                                                                    new FlatButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                          _flowQueryBloc.add(SkipNodeEvent(
                                                                              flowInstanceText: widget.code,
                                                                              nodeCode: node.code));
                                                                        },
                                                                        child: new Text(
                                                                            '确定')),
                                                                    new FlatButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: new Text(
                                                                            '取消'))
                                                                  ],
                                                                ),
                                                            context: context);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            })
                                          : null
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: <Widget>[
                                            Text("状态:${history.status}"),
                                            Text(
                                                '时间:${history.getFormatTime()}'),
                                          ],
                                        ));
                            } else {
                              return TimelineModel(
                                  title: node.name,
                                  isCurrent:
                                      _isCurrent(state.flowInstance, node),
                                  titleColor: _showNodeStatusColor(history),
                                  description:
                                      history == null ? "未开始" : history.status,
                                  customWidget: history == null
                                      ? null
                                      : Builder(builder: (context) {
                                          return Slidable(
                                            key: new Key(node.code),
                                            closeOnScroll: true,
                                            delegate:
                                                new SlidableDrawerDelegate(),
                                            actionExtentRatio: 0.25,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                Text(
                                                  "状态:${history.status}",
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Text(
                                                  '检验:${history.check_by}',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Text(
                                                  '时间:${history.getFormatTime()}',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            actions: <Widget>[
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: MaterialButton(
                                                  //height: 20,
                                                  color: Colors.red,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      side: BorderSide(
                                                          color:
                                                              Color(0xFFFFF00F),
                                                          style:
                                                              BorderStyle.solid,
                                                          width: 0)),
                                                  child: Text('重置'),
                                                  onPressed: widget
                                                          .userRepository
                                                          .authority
                                                          .can_reset_single
                                                      ? () {
                                                          _flowQueryBloc.add(
                                                              ResetSingleNodeEvent(
                                                                  node: node));
                                                        }
                                                      : null,
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                  onPressed: () {
                                    //已完成,显示完成的内容
                                    if (history.status.compareTo("已完成") == 0) {
                                      Navigator.push(context,
                                          new MaterialPageRoute(
                                              builder: (BuildContext context) {
                                        return new FlowHistoryDetail(
                                          flowHistory: history,
                                          userRepository: widget.userRepository,
                                        );
                                      }));
                                    } else if (history.status
                                            .compareTo("已跳过") ==
                                        0) {}
                                  });
                            }
                          }
                        }).toList(),
                        callback: onClickTimeLine,
                      ),
                      Container(
                        height: 20,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              );
            } else if (state is FlowQueryError) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
        );
      },
    );
  }
}
