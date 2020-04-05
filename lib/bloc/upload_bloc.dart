import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


//abstract class UpdateState extends Equatable {
//  UpdateState([List props = const []]) : super(props);
//}

abstract class UpdateState {
}

class InitState extends UpdateState {
  @override
  String toString() {
    return "InitState";
  }
}

class UpdateStartState extends InitState {}

class UpdatingState extends InitState {
  final double progress;
  UpdatingState({this.progress});
}

class UpdatedState extends InitState {}

abstract class UpdateEvent extends Equatable {
  UpdateEvent([List props = const []]) : super(props);
}

class StartUpdateEvent extends UpdateEvent {
  final platform;
  StartUpdateEvent({this.platform});
}

class RefreshUpdateProgressEvent extends UpdateEvent {
  double progress;
  RefreshUpdateProgressEvent({this.progress});
}

class UpdateFinishEvent extends UpdateEvent {
  UpdateFinishEvent();
}



class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  @override
  // TODO: implement initialState
  UpdateState get initialState => InitState();


  Stream<UpdateState> mapToState() async*{
    yield UpdatedState();
  }

  @override
  Stream<UpdateState> mapEventToState(UpdateEvent event) async* {
    if (event is StartUpdateEvent) {
        yield UpdateStartState();
    }else if(event is RefreshUpdateProgressEvent){
        yield UpdatingState(progress: event.progress);
    }else if(event is UpdateFinishEvent){
      yield UpdatedState();
    }
  }
}
