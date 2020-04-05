import 'dart:async';
import 'package:manufacture/data/repository/flow_nodes_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/flow_repository.dart';
abstract class FlowQueryState extends Equatable{
  FlowQueryState([List props = const[]]):super(props);
}

class FlowQueryStartState extends FlowQueryState{}

class FlowQueryLoadingState extends FlowQueryState{}

class FlowQueryError extends FlowQueryState{
  final String errorMessage;
  FlowQueryError({this.errorMessage});
}

class FlowQueryLoaded extends FlowQueryState{
  final List<Node> nodeList;
  final FlowInstance flowInstance;
  final List<FlowHistory> flowHistoryList;
  final String tipMsg;
  FlowQueryLoaded({@required this.nodeList,@required this.flowInstance,@required this.flowHistoryList,this.tipMsg});
}

class FlowQuerySuccess extends FlowQueryState{
  String msg;
  bool success;
  FlowQuerySuccess({this.success,this.msg});
}



abstract class FlowQueryEvent extends Equatable{
  FlowQueryEvent([List props = const[]]):super(props);
}

class FetchFlowQueryEventByFlowCode extends FlowQueryEvent{
  final String flowInstanceText;
  FetchFlowQueryEventByFlowCode({this.flowInstanceText});
}

class FetchFlowQueryEventByProductCode extends FlowQueryEvent{
  final String productCode;
  FetchFlowQueryEventByProductCode({this.productCode});
}

class BindProductEvent extends FlowQueryEvent{
  final String flowInstanceText;
  final String productCode;
  BindProductEvent({this.flowInstanceText, this.productCode});
}

class UnBindProductEvent extends FlowQueryEvent{
  String flowInstanceText;
  UnBindProductEvent({this.flowInstanceText});
}

class SkipNodeEvent extends FlowQueryEvent{
  final String flowInstanceText;
  final String nodeCode;
  SkipNodeEvent({this.flowInstanceText, this.nodeCode});
}

class FetchFlowInstanceRefreshEvent extends FlowQueryEvent{
  final String flowInstanceText;
  FetchFlowInstanceRefreshEvent({this.flowInstanceText});
}

class RestInstanceEvent extends FlowQueryEvent{
  final Node node;
  RestInstanceEvent({@required this.node});
}

class ResetSingleNodeEvent extends FlowQueryEvent{
  final Node node;
  ResetSingleNodeEvent({@required this.node});
}


class FlowQueryBloc extends Bloc<FlowQueryEvent, FlowQueryState>{
  final FlowRepository flowRepository;
  final FlowNodesRepository flowNodesRepository;
  List<Node> orderedList;
  FlowInstance _instance;


  FlowQueryBloc({@required this.flowRepository, this.flowNodesRepository}):assert(flowRepository!=null);
  @override
  // TODO: implement initialState
  FlowQueryState get initialState => FlowQueryStartState();

  Node getNextNode(List<Node> tempList, Node node){
    for(Node current in tempList) {
      //print("current-------${current.name}");
      if(node == null) {
        if(current.is_first==true) {
          //print("first---${current.name}");
          return current;
        }
      }else{
        if(node.next!=null) {
          if (node.next == current.id) {
            return current;
          }
        }
      }
    }
    return null;
  }

  List<Node> _buildFlow(List<Node> tempList)
  {
    List<Node> nodeList =[];
    //tempList.addAll(sourceList);
    //print(tempList.length);
    Node node;
    while(true) {
      node = getNextNode(tempList, node);
      if(node!=null)
        nodeList.add(node);
      else
        break;
      if(node.is_end==true) {
        break;
      }
      if(nodeList.length == tempList.length) {
        break;
      }
    }
    return nodeList;
  }

  @override
  Stream<FlowQueryState> mapEventToState(FlowQueryEvent event) async*{
    // TODO: implement mapEventToState
    if(event is FetchFlowQueryEventByProductCode){
      yield FlowQueryLoadingState();
      try {
        _instance =
        await flowRepository.fetchFlowInstanceByProductCode(event.productCode);
        print(_instance);
//        Procedure procedure = await flowRepository.fetchFlowModal(
//            _instance.modal);
//        print(procedure);
//        orderedList = _buildFlow(procedure.nodes);
        //orderedList = _buildFlow(await flowRepository.getModalNodes(_instance.modal));
        if(flowNodesRepository!=null)
          orderedList = flowNodesRepository.orderedNodes;
        else
          orderedList = _buildFlow(await flowRepository.getModalNodes(_instance.modal));
        List<FlowHistory> historyList = await flowRepository
            .fetchFlowHistoryList(_instance.id);
        yield FlowQueryLoaded(nodeList: orderedList,
            flowInstance: _instance,
            flowHistoryList: historyList);
      }catch(e){
        yield FlowQueryError(errorMessage: "无相关流水 ${event.productCode}");
      }
      //yield FlowQueryStartState();
    }else  if(event is FetchFlowQueryEventByFlowCode){
      yield FlowQueryLoadingState();
      try {
        _instance =
        await flowRepository.fetchFlowInstance(event.flowInstanceText);
        print(_instance);
//        Procedure procedure = await flowRepository.fetchFlowModal(
//            _instance.modal);
//        print(procedure);
//        orderedList = _buildFlow(procedure.nodes);
        orderedList = _buildFlow(await flowRepository.getModalNodes(_instance.modal));
        print(orderedList);
        List<FlowHistory> historyList = await flowRepository
            .fetchFlowHistoryList(_instance.id);
        yield FlowQueryLoaded(nodeList: orderedList,
            flowInstance: _instance,
            flowHistoryList: historyList);
      }catch(e){
        yield FlowQueryError(errorMessage: "无相关流水 ${event.flowInstanceText}");
      }
      //yield FlowQueryStartState();
    }else if(event is FetchFlowInstanceRefreshEvent) {
      yield FlowQueryLoadingState();
      _instance = await flowRepository.fetchFlowInstance(event.flowInstanceText);
//      if(_instance != null){
//        yield FlowQuerySuccess(success:true, msg: "操作成功");
//      }else{
//        yield FlowQuerySuccess(success:false, msg: "操作失败");
//      }
      List<FlowHistory> historyList=await flowRepository.fetchFlowHistoryList(_instance.id);
      yield FlowQueryLoaded(nodeList:orderedList,flowInstance: _instance,flowHistoryList: historyList);
    }else if(event is RestInstanceEvent){
      yield FlowQueryLoadingState();
      bool flag = await flowRepository.reset(flow: _instance, node: event.node);
      if(flag){
        yield FlowQuerySuccess(success:true, msg: "重置成功");
      }else{
        yield FlowQuerySuccess(success:false, msg: "重置失败");
      }
      _instance = await flowRepository.fetchFlowInstance(_instance.code);
      List<FlowHistory> historyList=await flowRepository.fetchFlowHistoryList(_instance.id);

      yield FlowQueryLoaded(nodeList:orderedList,flowInstance: _instance,flowHistoryList: historyList);
    }else if(event is BindProductEvent){
      yield  FlowQueryLoadingState();
      bool flag = await flowRepository.bind(flow: event.flowInstanceText, product: event.productCode);
      if(flag){
        yield FlowQuerySuccess(success:true, msg: "绑定成功");
      }else{
        yield FlowQuerySuccess(success:false, msg: "绑定失败");
      }
      _instance = await flowRepository.fetchFlowInstance(_instance.code);
      List<FlowHistory> historyList=await flowRepository.fetchFlowHistoryList(_instance.id);

      yield FlowQueryLoaded(nodeList:orderedList,flowInstance: _instance,flowHistoryList: historyList);
    }else if(event is UnBindProductEvent){
      yield  FlowQueryLoadingState();
      _instance = await flowRepository.fetchFlowInstance(event.flowInstanceText);
      bool flag = await flowRepository.unbind(instance: _instance);
      if(flag){
        yield FlowQuerySuccess(success:true, msg: "解绑成功");
      }else{
        yield FlowQuerySuccess(success:false, msg: "解绑失败");
      }
      _instance = await flowRepository.fetchFlowInstance(_instance.code);
      List<FlowHistory> historyList=await flowRepository.fetchFlowHistoryList(_instance.id);

      yield FlowQueryLoaded(nodeList:orderedList,flowInstance: _instance,flowHistoryList: historyList);
    }else if(event is SkipNodeEvent){
      yield  FlowQueryLoadingState();
      bool flag = await flowRepository.skip(flow: event.flowInstanceText, node: event.nodeCode);
      if(flag){
        yield FlowQuerySuccess(success:true, msg: "跳过成功");
      }else{
        yield FlowQuerySuccess(success:false, msg: "跳过失败");
      }
      _instance = await flowRepository.fetchFlowInstance(_instance.code);
      List<FlowHistory> historyList=await flowRepository.fetchFlowHistoryList(_instance.id);

      yield FlowQueryLoaded(nodeList:orderedList,flowInstance: _instance,flowHistoryList: historyList);
    }else if(event is ResetSingleNodeEvent){
      yield FlowQueryLoadingState();
      bool flag = await flowRepository.resetSingleNode(flow: _instance, node: event.node);
      if(flag){
        yield FlowQuerySuccess(success:true, msg: "重置成功");
      }else{
        yield FlowQuerySuccess(success:false, msg: "重置失败");
      }
      _instance = await flowRepository.fetchFlowInstance(_instance.code);
      List<FlowHistory> historyList=await flowRepository.fetchFlowHistoryList(_instance.id);

      yield FlowQueryLoaded(nodeList:orderedList,flowInstance: _instance,flowHistoryList: historyList);
    }
  }
}