import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/ui/widget/railway/railway.dart';
import 'package:manufacture/bloc/flow_modal_procedure_bloc.dart';
import 'package:manufacture/data/repository/flow_nodes_repository.dart';
import 'flow_node_add_edit_page.dart';
import 'package:manufacture/data/repository/record_type_repository.dart';
import 'package:manufacture/util/snackbar_util.dart';

class FlowModalProcedure extends StatefulWidget {
  final Procedure procedure;
  FlowModalProcedure({Key key, @required this.procedure}):super(key:key);
  @override
  State<StatefulWidget> createState() => _FlowModalProcedureState();
}

class _FlowModalProcedureState extends State<FlowModalProcedure> {
  FlowModalProcedureBloc _flowModalProcedureBloc;
  FlowNodesRepository _flowNodesRepository;
  RecordRepository _recordRepository;


  @override
  void initState() {
    _flowNodesRepository = FlowNodesRepository();
    _recordRepository = RecordRepository();
    _flowModalProcedureBloc = FlowModalProcedureBloc(flowNodesRepository: FlowNodesRepository());
    _flowModalProcedureBloc.add(LoadEvent(procedure: widget.procedure));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('流程管理'),
      ),
      body: Container(
        child: BlocListener<FlowModalProcedureBloc, FlowModalProcedureState>(
          bloc: _flowModalProcedureBloc,
          listener: (context, state){
            if(state is DeleteState){
              if(state.isSuccess){
                SnackBarUtil.success(context: context, message: "删除成功");
              }else{
                SnackBarUtil.fail(context: context, message: "删除失败");
              }
            }else if(state is MoveState){
              if(state.isSuccess){
                SnackBarUtil.success(context: context, message: "移动成功");
              }else{
                SnackBarUtil.fail(context: context, message: "移动失败");
              }
            }
          },
          child: BlocBuilder<FlowModalProcedureBloc, FlowModalProcedureState>(
            bloc: _flowModalProcedureBloc,
            condition: (previous, current){
              return true;
            },
            builder: (context,state){
              if(state is LoadedState){
                //print(state.nodes);
                if(state.nodes.length!=0){
                  return RailWay(
                  actionBuilder: (context, index) {
                    return PopupMenuButton(
                      //color: Theme.of(context).accentColor,
                      icon: Icon(Icons.list,color: Theme.of(context).accentColor,),
                      itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                        PopupMenuItem<String>(
                          value: "insertUp",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.file_upload,
                                color: Theme.of(context).accentColor,
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Text('向上增加'),
                              )
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: "insertDown",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.file_download,
                                color: Theme.of(context).accentColor,
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Text('向下增加'),
                              )
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: "up",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.arrow_upward,
                                color: Theme.of(context).accentColor,
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Text('上移'),
                              )
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: "down",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.arrow_downward,
                                color: Theme.of(context).accentColor,
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Text('下移'),
                              )
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: "modify",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.mode_edit,
                                color: Theme.of(context).accentColor,
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Text('修改'),
                              )
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: "remove",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                              Container(
                                margin: const EdgeInsets.all(10),
                                child: Text('删除'),
                              )
                            ],
                          ),
                        ),
                      ],
                      onSelected: (String result) {
                        if (result.compareTo("up") == 0) {
                          _flowModalProcedureBloc.add(MoveEvent(node: state.nodes[index],style: MoveStyle.UP));
                        }else if (result.compareTo("down") == 0) {
                          _flowModalProcedureBloc.add(MoveEvent(node: state.nodes[index],style: MoveStyle.DOWN));
                        }else if (result.compareTo("modify") == 0) {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context){
                              return NodeAddEditScreen(procedure: widget.procedure,modifyNode: state.nodes[index],recordRepository: _recordRepository,flowNodesRepository: _flowNodesRepository,);
                            }
                          ));
                        }else if (result.compareTo('remove') == 0) {
                          //_flowModalProcedureBloc.dispatch(DeleteEvent(node: state.nodes[index]));
                          showDialog(
                              builder: (context) => new AlertDialog(
                                title: new Text('提示'),
                                content: new Text('确定要删除'),
                                actions: <Widget>[
                                  new FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _flowModalProcedureBloc.add(DeleteEvent(node: state.nodes[index]));
                                      },
                                      child: new Text('确定')),
                                  new FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: new Text('取消'))
                                ],
                              ),
                              context: context);
                        }else if (result.compareTo('insertUp') == 0) {
                            Navigator.push(context, MaterialPageRoute<bool>(
                                builder: (context){
                                  return NodeAddEditScreen(procedure: widget.procedure,recordRepository: _recordRepository,type: NodeOperateType.ADD,modifyNode: state.nodes[index],flowNodesRepository: _flowNodesRepository,);
                                }
                            )).then((result){
                              if(result!=null){
                                _flowModalProcedureBloc.add(LoadEvent(procedure: widget.procedure)) ;
                              }
                            });
                        }else if (result.compareTo('insertDown') == 0) {
                          Node node;
                          if(index == state.nodes.length-1)
                          {
                             node = null;
                          }else{
                             node = state.nodes[index+1];
                          }
                          Navigator.push(context, MaterialPageRoute<bool>(
                              builder: (context){
                                return NodeAddEditScreen(procedure: widget.procedure,recordRepository: _recordRepository,type: NodeOperateType.ADD,modifyNode: node,flowNodesRepository: _flowNodesRepository,);
                              }
                          )).then((result){
                            if(result!=null){
                              _flowModalProcedureBloc.add(LoadEvent(procedure: widget.procedure)) ;
                            }
                          });
                        }
                      },
                    );
                  },
                  stations: state.nodes.map<Station>((node){
                    return Station(
                        title: node.name,
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ListTile(dense: true, title: Text(node.code),),
                          ],
                        ),
                    );
                  }).toList(),
                );
                }else{
                  return Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('无节点，点击添加！'),
                          IconButton(
                            icon: Icon(Icons.add,color: Theme.of(context).accentColor,),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute<bool>(
                                  builder: (context){
                                    return NodeAddEditScreen(procedure: widget.procedure,recordRepository: _recordRepository,type: NodeOperateType.ADD,modifyNode: null,flowNodesRepository: _flowNodesRepository,);
                                  }
                              )).then((result){
                                if(result!=null){
                                  _flowModalProcedureBloc.add(LoadEvent(procedure: widget.procedure)) ;
                                }
                              });
                            },
                          ),
                        ],
                      )
                  );
                }
              }else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
