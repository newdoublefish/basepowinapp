import 'dart:async';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/data/repository/flow_nodes_repository.dart';
import 'package:manufacture/data/repository/flow_repository.dart';
import 'package:manufacture/ui/pages/flow_detail_page.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/project.dart';

class FlowInstanceProcessState {}

class InitState extends FlowInstanceProcessState {}

class LoadedState extends FlowInstanceProcessState {
  final List<Node> orderNodeList;
  final FlowInstance instance;
  LoadedState({this.orderNodeList, this.instance});
}

class DoneState extends FlowInstanceProcessState {
  final bool isSuccess;
  final String message;
  DoneState({this.isSuccess, this.message});
}

class FlowInstanceProcessEvent {}

class StartEvent extends FlowInstanceProcessEvent {
  final FlowInstance instance;
  StartEvent({this.instance});
}

class LoadEvent extends FlowInstanceProcessEvent {
  final FlowInstance instance;
  LoadEvent({this.instance});
}

class ResetSingleNodeEvent extends FlowInstanceProcessEvent {
  final FlowInstance instance;
  final Node node;
  ResetSingleNodeEvent({this.instance, this.node});
}

class ResetNodesEvent extends FlowInstanceProcessEvent {
  final FlowInstance instance;
  final Node node;
  ResetNodesEvent({this.instance, this.node});
}

class SkipEvent extends FlowInstanceProcessEvent {
  final FlowInstance instance;
  final Node node;
  SkipEvent({this.instance, this.node});
}

class ConfirmEvent extends FlowInstanceProcessEvent {
  final FlowInstance instance;
  final Node node;
  ConfirmEvent({this.instance, this.node});
}

class BindProductEvent extends FlowInstanceProcessEvent{
  final FlowInstance instance;
  final String productCode;
  BindProductEvent({this.instance, this.productCode});
}

class UnBindProductEvent extends FlowInstanceProcessEvent{
  final FlowInstance instance;
  UnBindProductEvent({this.instance});
}

class FlowInstanceProcessBloc
    extends Bloc<FlowInstanceProcessEvent, FlowInstanceProcessState> {
  final FlowNodesRepository flowNodesRepository;
  final FlowInstanceObjectRepository flowInstanceObjectRepository;
  FlowInstanceProcessBloc(
      {@required this.flowNodesRepository,
      @required this.flowInstanceObjectRepository})
      : assert(
            flowNodesRepository != null, flowInstanceObjectRepository != null);

  @override
  FlowInstanceProcessState get initialState => InitState();

  @override
  Stream<FlowInstanceProcessState> mapEventToState(
      FlowInstanceProcessEvent event) async* {
    if (event is StartEvent) {
      if (flowNodesRepository.orderedNodes.length == 0)
        await flowNodesRepository.getNodes(modalId: event.instance.modal);
      yield LoadedState(
          orderNodeList: flowNodesRepository.orderedNodes,
          instance: event.instance);
    } else if (event is ResetSingleNodeEvent) {
      ReqResponse flag = await flowInstanceObjectRepository.resetSingleNode(
          flow: event.instance, node: event.node);
      if (flag.isSuccess) {
        yield DoneState(isSuccess: true, message: "重置成功");
        yield LoadedState(
            orderNodeList: flowNodesRepository.orderedNodes,
            instance: event.instance);
      } else {
        yield DoneState(isSuccess: false, message: "重置失败 ${flag.message}");
      }
    } else if (event is ResetNodesEvent) {
      ReqResponse flag = await flowInstanceObjectRepository.resetNodes(
          flow: event.instance, node: event.node);
      if (flag.isSuccess) {
        yield DoneState(isSuccess: true, message: "重置成功");
        yield LoadedState(
            orderNodeList: flowNodesRepository.orderedNodes,
            instance: event.instance);
      } else {
        yield DoneState(isSuccess: false, message: "重置失败 ${flag.message}");
      }
    }else if (event is SkipEvent) {
      bool flag = await flowInstanceObjectRepository.skip(instance: event.instance, node: event.node);
      if(flag){
        yield DoneState(isSuccess: true, message: "跳过成功");
        yield LoadedState(
            orderNodeList: flowNodesRepository.orderedNodes,
            instance: event.instance);
      }else{
        yield DoneState(isSuccess: false, message: "跳过失败");
      }
    }else if (event is ConfirmEvent) {
      bool flag = await flowInstanceObjectRepository.verify(instance: event.instance, node: event.node);
      if(flag){
        yield DoneState(isSuccess: true, message: "审核成功");
        yield LoadedState(
            orderNodeList: flowNodesRepository.orderedNodes,
            instance: event.instance);
      }else{
        yield DoneState(isSuccess: false, message: "审核失败");
      }
    }else if(event is BindProductEvent){
      ReqResponse flag = await flowInstanceObjectRepository.bind(flow: event.instance.code, product: event.productCode);
      if(flag.isSuccess){
        yield DoneState(isSuccess: true, message: "绑定成功");
        yield LoadedState(
            orderNodeList: flowNodesRepository.orderedNodes,
            instance: event.instance);
      }else{
        yield DoneState(isSuccess: false, message: "绑定失败 ${flag.message}");
      }
    }else if(event is UnBindProductEvent){
      ReqResponse response = await flowInstanceObjectRepository.unbind(instance: event.instance);
      if(response.isSuccess){
        yield DoneState(isSuccess: true, message: "解绑成功");
        yield LoadedState(
            orderNodeList: flowNodesRepository.orderedNodes,
            instance: event.instance);
      }else{
        yield DoneState(isSuccess: false, message: response.message);
      }
    }
  }
}
