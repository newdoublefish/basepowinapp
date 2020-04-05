import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/data/repository/ship_repository.dart';
import 'package:manufacture/data/repository/flow_repository.dart';

abstract class ShipOrderState extends Equatable{
  ShipOrderState([List props = const[]]):super(props);
}

class InitState extends ShipOrderState{}

class LoadingState extends ShipOrderState{}

class AddResponseState extends ShipOrderState{
  final bool success;
  final String msg;
  final List<ShipInfo> shipInfoList;
  AddResponseState({this.success,this.msg,this.shipInfoList});
}

class LoadedState extends ShipOrderState{
  final List<ShipDetail> shipDetailList;
  final ShipOrder shipOrder;
  LoadedState({@required this.shipOrder,@required this.shipDetailList});
}

abstract class ShipOrderEvent extends Equatable{
  ShipOrderEvent([List props = const[]]):super(props);
}

class SearchEvent extends ShipOrderEvent{
  final String code;
  SearchEvent({@required this.code});
}

class AddEvent extends ShipOrderEvent{
  final String flowCode;
  AddEvent({@required this.flowCode});
}

class ShipOrderBloc extends Bloc<ShipOrderEvent, ShipOrderState>{
  final ShipRepository shipRepository;
  ShipOrderBloc({@required this.shipRepository});
  @override
  // TODO: implement initialState
  ShipOrderState get initialState => InitState();

  @override
  Stream<ShipOrderState> mapEventToState(ShipOrderEvent event) async*{
    // TODO: implement mapEventToState
    if(event is SearchEvent) {
      yield LoadingState();
      ShipOrder shipOrder = await shipRepository.getShipOrder(code: event.code);
      if (shipOrder == null) {
        yield InitState();
      }else {
        List<ShipDetail> detailList = await shipRepository.getShipDetailList(
            orderId: shipOrder.id);
        yield LoadedState(shipOrder: shipOrder, shipDetailList: detailList);
      }
    }
//    }else if(event is AddEvent){
//      yield LoadingState();
//      //Node node = await flowRepository.getNode(f)
//      FlowInstance instance = await flowRepository.fetchFlowInstance(event.flowCode);
//      print(instance);
//      if(instance==null){
//        yield AddResponseState(success:false,msg: "添加失败");
//        return;
//      }
//      Node node = await flowRepository.getNode(instance.current_node);
//      print(node);
//      if(node.node_type !=2)
//      {
//        yield LoadedState(shipOrder: shipOrder, shipInfoList: shipInfoList);
//        return;
//      }
//      if(await shipRepository.create(order: shipOrder,flowText: instance.code,nodeText: node.code)){
//          if(await flowRepository.commit(flow: instance.code,node: node.code)){
//            shipInfoList = await shipRepository.listShipInfoOfShipOrder(shipOrder.id);
//            yield AddResponseState(success:true,msg: "添加成功", shipInfoList: shipInfoList);
//          }else{
//            yield AddResponseState(success:false,msg: "添加失败");
//          }
//      }else{
//        yield AddResponseState(success:false,msg: "添加失败");
//      }
//    }
  }
}