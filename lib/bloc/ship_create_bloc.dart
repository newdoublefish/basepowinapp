import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/ship.dart';
import 'package:manufacture/data/repository/ship_repository.dart';

abstract class CreateShipState extends Equatable{
  CreateShipState([List props = const[]]):super(props);
}

class InitState extends CreateShipState{}

class LoadingState extends CreateShipState{}

class ShipModalLoadedState extends CreateShipState{
  final List<ShipModal> shipModalList;
  ShipModalLoadedState({@required this.shipModalList});
}

class ShipModalSelectedState extends CreateShipState{
  final ShipModal shipModal;
  ShipModalSelectedState({@required this.shipModal});
}

class ShipModalLoadedErrorState extends CreateShipState{}

class ShipCreateSuccessState extends CreateShipState{
  final ShipModal modal;
  ShipCreateSuccessState({@required this.modal});
}

class ShipCreateErrorState extends CreateShipState{
  final ShipModal modal;
  ShipCreateErrorState({@required this.modal});
}

abstract class CreateShipEvent extends Equatable{
  CreateShipEvent([List props = const[]]):super(props);
}

class FetchShipModalEvent extends CreateShipEvent{}

class SelectShipModalEvent extends CreateShipEvent{
  final ShipModal shipModal;
  SelectShipModalEvent({@required this.shipModal});
}

class CommitNewShipEvent extends CreateShipEvent{
  final ShipOrder order;
  final ShipModal modal;
  CommitNewShipEvent({@required this.order, @required this.modal});
}

class CreateShipBloc extends Bloc<CreateShipEvent, CreateShipState>{
  final ShipRepository shipRepository;
  CreateShipBloc({@required this.shipRepository});

  @override
  // TODO: implement initialState
  CreateShipState get initialState => InitState();

  @override
  Stream<CreateShipState> mapEventToState(CreateShipEvent event) async*{
    // TODO: implement mapEventToState
    if(event is FetchShipModalEvent){
        List<ShipModal> _list = await shipRepository.listShipModal();
        print(_list);
        yield ShipModalLoadedState(shipModalList: _list);
    }else if(event is SelectShipModalEvent){
      yield LoadingState();
      yield ShipModalSelectedState(shipModal: event.shipModal);
    }else if(event is CommitNewShipEvent){
      yield LoadingState();
      bool flag = await shipRepository.createShipOrder(order: event.order);
      if(flag)
        yield ShipCreateSuccessState(modal: event.modal);
      else
        yield ShipCreateErrorState(modal: event.modal);
    }
  }
}