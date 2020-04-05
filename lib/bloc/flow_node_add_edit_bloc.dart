import 'package:manufacture/beans/req_response.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/project.dart';
import 'dart:async';
import 'package:manufacture/data/repository/flow_nodes_repository.dart';

class NodeAddEditState{}
class InitState extends NodeAddEditState{}
class LoadedState extends NodeAddEditState{}
class AddedState extends NodeAddEditState{
  final bool isSuccess;
  AddedState({this.isSuccess});
}

class ModifyState extends NodeAddEditState{
  final bool isSuccess;
  ModifyState({this.isSuccess});
}

class NodeAddEditEvent{}

class AddEvent extends NodeAddEditEvent{
  final Node node;
  AddEvent({this.node});
}

class ModifyEvent extends NodeAddEditEvent{
  final Node node;
  ModifyEvent({this.node});
}

class NodeAddEditBloc extends Bloc<NodeAddEditEvent, NodeAddEditState>{
  final FlowNodesRepository flowNodesRepository;
  NodeAddEditBloc({this.flowNodesRepository});

  @override
  // TODO: implement initialState
  NodeAddEditState get initialState => InitState();

  @override
  Stream<NodeAddEditState> mapEventToState(NodeAddEditEvent event) async*{
    if(event is AddEvent){
      ReqResponse<Node> req = await flowNodesRepository.create(node: event.node);
      yield AddedState(isSuccess: req.isSuccess);
    }else if(event is ModifyEvent){
      print(event.node);
      ReqResponse<Node> req = await flowNodesRepository.update(node: event.node);
      yield AddedState(isSuccess: req.isSuccess);
    }
  }

}

