import 'package:manufacture/beans/req_response.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/project.dart';
import 'dart:async';
import 'package:manufacture/data/repository/flow_nodes_repository.dart';

enum MoveStyle{
  UP,
  DOWN
}

abstract class FlowModalProcedureState{}
class InitState extends FlowModalProcedureState{}
class LoadedState extends FlowModalProcedureState{
  final List<Node> nodes;
  LoadedState({this.nodes});
}


class DeleteState extends FlowModalProcedureState{
  final bool isSuccess;
  DeleteState({this.isSuccess});
}

class MoveState extends FlowModalProcedureState{
  final bool isSuccess;
  MoveState({this.isSuccess});
}

abstract class FlowModalProcedureEvent{}
class LoadEvent extends FlowModalProcedureEvent{
  final Procedure procedure;
  LoadEvent({@required this.procedure});
}

class DeleteEvent extends FlowModalProcedureEvent{
  final Node node;
  DeleteEvent({@required this.node});
}

class MoveEvent extends FlowModalProcedureEvent{
  final MoveStyle style;
  final Node node;
  MoveEvent({@required this.node, @required this.style});
}


class FlowModalProcedureBloc extends Bloc<FlowModalProcedureEvent, FlowModalProcedureState>{
  final FlowNodesRepository flowNodesRepository;
  FlowModalProcedureBloc({@required this.flowNodesRepository});
  @override
  // TODO: implement initialState
  FlowModalProcedureState get initialState => InitState();

  @override
  Stream<FlowModalProcedureState> mapEventToState(FlowModalProcedureEvent event) async*{
    if(event is LoadEvent){
      ReqResponse req =  await flowNodesRepository.getNodes(modalId: event.procedure.id);
      //print(flowNodesRepository.orderedNodes);
      if(req.isSuccess){
        yield LoadedState(nodes: flowNodesRepository.orderedNodes);
      }else{
        yield LoadedState(nodes: []);
      }
    }else if(event is DeleteEvent){
      bool isSuccess = await flowNodesRepository.delete(node: event.node);
      yield DeleteState(isSuccess: isSuccess);

      ReqResponse req =  await flowNodesRepository.getNodes(modalId: event.node.modal);
      //print(flowNodesRepository.orderedNodes);
      if(req.isSuccess){
        yield LoadedState(nodes: flowNodesRepository.orderedNodes);
      }else{
        yield LoadedState(nodes: []);
      }
    }else if(event is MoveEvent){
      bool isSuccess = false;
      if(event.style == MoveStyle.UP)
        isSuccess = await flowNodesRepository.moveUp(node: event.node);
      if(event.style == MoveStyle.DOWN)
        isSuccess = await flowNodesRepository.moveDown(node: event.node);
      yield MoveState(isSuccess: isSuccess);

      ReqResponse req =  await flowNodesRepository.getNodes(modalId: event.node.modal);
      //print(flowNodesRepository.orderedNodes);
      if(req.isSuccess){
        yield LoadedState(nodes: flowNodesRepository.orderedNodes);
      }else{
        yield LoadedState(nodes: []);
      }
    }
  }

}
