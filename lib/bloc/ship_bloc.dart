import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/data/repository/ship_repository.dart';
import 'package:manufacture/data/repository/flow_repository.dart';

abstract class ShipState extends Equatable{
  ShipState([List props = const[]]):super(props);
}

class ShipInitState extends ShipState{}

class ShipOrderLoadedState extends ShipState{
    final ShipOrder order;
    ShipOrderLoadedState({this.order});
}

class CommitSuccessState extends ShipState{
  final ShipOrder order;
  CommitSuccessState({this.order});
}

abstract class ShipEvent extends Equatable{
  ShipEvent([List props = const[]]):super(props);
}

class FetchShipInfoEvent extends ShipEvent{
  final String code;
  FetchShipInfoEvent({this.code});
}

class ResetEvent extends ShipEvent{}

class CommitEvent extends ShipEvent{
  final String flow;
  final String node;
  CommitEvent({this.flow,this.node});
}


class ShipBloc extends Bloc<ShipEvent, ShipState>{
  final ShipRepository shipRepository;
  final FlowRepository flowRepository;
  ShipOrder shipOrder;
  ShipBloc({@required this.shipRepository, @required this.flowRepository});

  @override
  // TODO: implement initialState
  ShipState get initialState => ShipInitState();

  @override
  Stream<ShipState> mapEventToState(ShipEvent event) async*{
    // TODO: implement mapEventToState
    if(event is FetchShipInfoEvent){
      shipOrder = await shipRepository.getShipOrder(code: event.code);
      print(shipOrder);
      if(shipOrder ==null)
        yield ShipInitState();
      else
        yield ShipOrderLoadedState(order: shipOrder);
    }else if(event is ResetEvent){
      yield ShipInitState();
    }else if(event is CommitEvent) {
//      await shipRepository.create(order: shipOrder,flowText: event.flow,nodeText: event.node);
//      await flowRepository.commit(flow: event.flow,node: event.node);
      yield CommitSuccessState(order: shipOrder);
    }
  }

}