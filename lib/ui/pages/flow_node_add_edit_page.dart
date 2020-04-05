import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/technology.dart';
import 'package:manufacture/bloc/flow_node_add_edit_bloc.dart';
import 'package:manufacture/core/object_select_widget.dart';
import 'package:manufacture/data/repository/flow_nodes_repository.dart';
import 'package:manufacture/data/repository/record_type_repository.dart';
import 'package:manufacture/bloc/record_type_select_bloc.dart';
import 'package:manufacture/beans/record.dart';
import 'package:manufacture/data/repository/tech_repository.dart';
import 'package:manufacture/util/snackbar_util.dart';

import '../../core/object_select_dialog.dart';
import '../../core/object_selector.dart';

enum NodeOperateType { ADD, MODIFY }

class NodeAddEditScreen extends StatefulWidget {
  final Procedure procedure;
  final Node modifyNode;
  final NodeOperateType type;
  final FlowNodesRepository flowNodesRepository;
  final RecordRepository recordRepository;
  NodeAddEditScreen(
      {Key key,
      this.procedure,
      this.modifyNode,
      this.type = NodeOperateType.MODIFY,
      this.flowNodesRepository,
      this.recordRepository})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _NodeAddEditScreenState();
}

class _NodeAddEditScreenState extends State<NodeAddEditScreen> {
  NodeAddEditBloc _nodeAddEditBloc;
  RecordTypeBloc _recordTypeBloc;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  bool needCheck = false;
  bool outFlow = false;
  bool isWorkShare = false;
  bool canSkip = false;
  Node node;

  int nodeType;
  int typeId;

  //RecordType _recordType;

  _showDialog(String mention) {
    showDialog(
        builder: (context) => new AlertDialog(
              title: new Text('提示'),
              content: new Text('$mention成功'),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                      Navigator.pop(context, true);
                    },
                    child: new Text('确定'))
              ],
            ),
        context: context);
  }

  @override
  void initState() {
    _nodeAddEditBloc =
        NodeAddEditBloc(flowNodesRepository: widget.flowNodesRepository);
    _recordTypeBloc = RecordTypeBloc(repository: widget.recordRepository);
    if (widget.type == NodeOperateType.MODIFY && widget.modifyNode != null) {
      nodeType = widget.modifyNode.node_type;
      typeId = widget.modifyNode.type_id;

      node = widget.modifyNode;
      _codeController.text = widget.modifyNode.code;
      _nameController.text = widget.modifyNode.name;
      needCheck = widget.modifyNode.need_check;
      outFlow = widget.modifyNode.out_flow;
      isWorkShare = widget.modifyNode.is_work_share;
      canSkip = widget.modifyNode.can_skip;

      _recordTypeBloc
          .add(RecordTypeDoSelectEvent(typeId: widget.modifyNode.type_id));
    } else {
      node = Node();
      _recordTypeBloc.add(RecordTypeLoadEvent());
    }
    super.initState();
  }

  @override
  void dispose() {
    _recordTypeBloc.close();
    _nodeAddEditBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.type == NodeOperateType.MODIFY ? "修改" : "增加"),
        ),
        body: BlocListener<NodeAddEditBloc, NodeAddEditState>(
          listener: (context, state) {
            if (state is AddedState) {
              if (state.isSuccess) {
                _showDialog("提交成功");
              } else {
                SnackBarUtil.fail(context: context, message: "提交失败");
              }
            }
          },
          bloc: _nodeAddEditBloc,
          child: BlocBuilder<NodeAddEditBloc, NodeAddEditState>(
            bloc: _nodeAddEditBloc,
            condition: (pre, current) {
              return true;
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          controller: _codeController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "内容不能为空";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.code,
                              color: Theme.of(context).accentColor,
                            ),
                            labelText: '编号',
                            //hintText: '编号',
                            //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
                          ),
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
                            prefixIcon: Icon(
                              Icons.mode_edit,
                              color: Theme.of(context).accentColor,
                            ),
                            labelText: '名称',
                            //hintText: '名称',
                            //border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(20.0)),)
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: needCheck,
                                    onChanged: (val) {
                                      setState(() {
                                        needCheck = val;
                                      });
                                    },
                                  ),
                                  Text("需要审核"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: outFlow,
                                    onChanged: (val) {
                                      setState(() {
                                        outFlow = val;
                                      });
                                    },
                                  ),
                                  Text("允许线外操作"),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: isWorkShare,
                                    onChanged: (val) {
                                      setState(() {
                                        isWorkShare = val;
                                      });
                                    },
                                  ),
                                  Text("需要工作共享"),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Checkbox(
                                    value: canSkip,
                                    onChanged: (val) {
                                      setState(() {
                                        canSkip = val;
                                      });
                                    },
                                  ),
                                  Text("允许跳过"),
                                ],
                              ),
                            ),
                          ],
                        ),
//                        Container(
//                          child: BlocBuilder<RecordTypeBloc,
//                              RecordTypeSelectState>(
//                            bloc: _recordTypeBloc,
//                            builder: (context, state) {
//                              if (state is RecordTypeLoadState) {
//                                _recordType = state.current;
//                                return DropdownButton<RecordType>(
//                                  value: _recordType,
//                                  onChanged: (RecordType newValue) {
//                                    _recordTypeBloc.dispatch(
//                                        RecordTypeDoSelectEvent(
//                                            typeId: newValue.id));
//                                  },
//                                  items: state.recordTypeList
//                                      .map<DropdownMenuItem<RecordType>>(
//                                          (RecordType value) {
//                                    return DropdownMenuItem<RecordType>(
//                                      value: value,
//                                      child: Text(value.name),
//                                    );
//                                  }).toList(),
//                                );
//                              }
//                              return Center(
//                                child: CircularProgressIndicator(),
//                              );
//                            },
//                          ),
//                        ),

                        _WorkTypeSelect(nodeType: nodeType, typeId: typeId, selectCallBack: (type, id){
                          print("on selected $nodeType, $typeId");
                          nodeType = type;
                          typeId = id;
                        },),

                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  side: BorderSide(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2)),
                              color: Theme.of(context).accentColor,
                              child: Text("提交"),
                              onPressed: () {
                                if (_formKey.currentState.validate() &&
                                    widget.type == NodeOperateType.ADD) {

                                  node.name = _nameController.text.toString();
                                  node.code = _codeController.text.toString();
                                  node.is_work_share = isWorkShare;
                                  node.can_skip = canSkip;
                                  node.need_check = needCheck;
                                  node.out_flow = outFlow;
                                  node.node_type = nodeType;
                                  node.type_id = typeId;
//                                  if (_recordType != null)
//                                    node.type_id = _recordType.id;
                                  node.is_first = false;
                                  node.is_end = false;
                                  if (widget.modifyNode == null)
                                    node.next = null;
                                  else
                                    node.next = widget.modifyNode.id;
                                  node.modal = widget.procedure.id;
                                  print(node);
                                  _nodeAddEditBloc
                                      .add(AddEvent(node: node));
                                } else if (_formKey.currentState.validate() &&
                                    widget.type == NodeOperateType.MODIFY) {
                                  widget.modifyNode.name = _nameController.text.toString();
                                  widget.modifyNode.code = _codeController.text.toString();
                                  widget.modifyNode.is_work_share = isWorkShare;
                                  widget.modifyNode.can_skip = canSkip;
                                  widget.modifyNode.need_check = needCheck;
                                  widget.modifyNode.out_flow = outFlow;
                                  widget.modifyNode.node_type = nodeType;
                                  widget.modifyNode.type_id = typeId;
//                                  if (_recordType != null)
//                                      widget.modifyNode.type_id = _recordType.id;
                                  _nodeAddEditBloc
                                      .add(ModifyEvent(node: widget.modifyNode));
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}

typedef SelectCallBack = void Function(int workType, int typeId);

class _WorkTypeSelect extends StatefulWidget{
  final int nodeType;
  final int typeId;
  final SelectCallBack selectCallBack;
  _WorkTypeSelect({Key key, this.nodeType,this.typeId,this.selectCallBack}):super(key:key);
  @override
  State<StatefulWidget> createState() =>_WorkTypeSelectState();
}

class _WorkTypeSelectState extends State<_WorkTypeSelect>{
  RecordTypeRepository _recordTypeRepository;
  TechnologyModalRepository _technologyModalRepository;
  ObjectSelectController<RecordType> _recordTypeSelectController =
  new ObjectSelectController();
  ObjectSelectController<TechnologyModal> _techModalSelectController =
  new ObjectSelectController();
  int nodeType;
  int typeId;

  @override
  void initState() {
    nodeType = widget.nodeType;
    typeId = widget.typeId;
    _recordTypeRepository = RecordTypeRepository.init();
    _technologyModalRepository = TechnologyModalRepository.init();
    if(widget.nodeType==0){
      _recordTypeSelectController.selectObject = RecordType()..id=widget.typeId;
    }else{
      _techModalSelectController.selectObject = TechnologyModal()..id=widget.typeId;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 24,
          ),
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: "节点类型",
            ),
            onChanged: (int value) {
              setState(() {
                nodeType = value;
                typeId = null;
              });
            },
            value: nodeType,
            items: [
              DropdownMenuItem<int>(
                value: 0,
                child: Text("测试"),
              ),
              DropdownMenuItem<int>(
                value: 1,
                child: Text("工艺"),
              ),
            ],
          ),

          SizedBox(
            height: 24,
          ),

          Builder(builder: (context){
            if(nodeType==null){
              return Container();
            }
            if(nodeType==0){
              return ObjectSelector<RecordType>(
                objectRepository: _recordTypeRepository,
                title: "测试类型",
                buildValueText: (BaseBean detail) {
                  return (detail as RecordType).name;
                },
                object: typeId!=null?(RecordType()..id=typeId):null,
                //controller: _recordTypeSelectController,
                onSelectCallBack: (BaseBean value){
                  typeId = value.id;
                  if(widget.selectCallBack!=null){
                    widget.selectCallBack(nodeType,typeId);
                  }
                },
                objectSelectDialog: ObjectSelectDialog(tobeSelectList: [
                  ObjectTobeSelect<RecordType>(
                      title: "测试类型",
                      buildQueryParam: (BaseBean t) {
                        return null;
                      },
                      objectRepository: _recordTypeRepository,
                      buildObjectItem: (BaseBean t) {
                        return Text(((t as RecordType).name));
                      }),
                ]),
              );
            }else{
              return ObjectSelector<TechnologyModal>(
                objectRepository: _technologyModalRepository,
                title: "工艺类型",
                buildValueText: (BaseBean detail) {
                  return (detail as TechnologyModal).name;
                },
                object: typeId!=null?(TechnologyModal()..id=typeId):null,
                //controller: _techModalSelectController,
                onSelectCallBack: (BaseBean value){
                  typeId = value.id;
                  if(widget.selectCallBack!=null){
                    widget.selectCallBack(nodeType,typeId);
                  }
                },
                objectSelectDialog: ObjectSelectDialog(tobeSelectList: [
                  ObjectTobeSelect<TechnologyModal>(
                      title: "工艺类型",
                      buildQueryParam: (BaseBean t) {
                        return null;
                      },
                      objectRepository: _technologyModalRepository,
                      buildObjectItem: (BaseBean t) {
                        return Text(((t as TechnologyModal).name));
                      }),
                ]),
              );
            }
          },),
        ],
      ),
    );
  }
}
