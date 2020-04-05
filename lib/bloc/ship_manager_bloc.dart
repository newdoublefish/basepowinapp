import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/data/repository/ship_repository.dart';
import 'package:manufacture/data/repository/flow_repository.dart';

abstract class ShipManagerState extends Equatable{
  ShipManagerState([List props = const[]]):super(props);
}

class ShipManagerStateInitState extends ShipManagerState{}

class LoadedState extends ShipManagerState{
  final List<ShipOrder> shipOrderList;
  LoadedState({@required this.shipOrderList});
}

class LoadingState extends ShipManagerState{}



abstract class ShipManagerEvent extends Equatable{
  ShipManagerEvent([List props = const[]]):super(props);
}

class LoadEvent extends ShipManagerEvent{
}

class ShipManagerBloc extends Bloc<ShipManagerEvent, ShipManagerState>{
  final ShipRepository shipRepository;
  ShipManagerBloc({@required this.shipRepository});

  @override
  // TODO: implement initialState
  ShipManagerState get initialState => ShipManagerStateInitState();

  @override
  Stream<ShipManagerState> mapEventToState(ShipManagerEvent event) async*{
    // TODO: implement mapEventToState
    if(event is LoadEvent){
      yield LoadingState();
      List<ShipOrder> shipOrderList = await shipRepository.listShipOrder();
      yield LoadedState(shipOrderList: shipOrderList);
    }
  }
}