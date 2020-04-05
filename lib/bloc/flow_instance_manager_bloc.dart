import 'dart:async';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/ui/pages/flow_detail_page.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/flow_repository.dart';

class FlowInstanceManagerState {}

class InitState extends FlowInstanceManagerState {}

class LoadingState extends FlowInstanceManagerState {}

class LoadedState extends FlowInstanceManagerState {
  final List<FlowInstance> list;
  LoadedState({this.list});
}

class NoMoreState extends FlowInstanceManagerState {}

class MoreLoadedState extends FlowInstanceManagerState {}

class RefreshedState extends FlowInstanceManagerState{}

class DoneState extends FlowInstanceManagerState {
  final bool isSuccess;
  final String message;
  DoneState({this.isSuccess, this.message});
}

class DeleteStartState extends FlowInstanceManagerState{}
class DeletingState extends FlowInstanceManagerState{
  final double progress;
  DeletingState({this.progress});
}
class DeletedState extends FlowInstanceManagerState{}

class FlowInstanceManagerEvent {}

class RefreshEvent extends FlowInstanceManagerEvent {
  final Detail detail;
  final Map<String, dynamic> queryParams;
  RefreshEvent({@required this.detail, this.queryParams})
      : assert(detail != null);
}

class LoadMoreEvent extends FlowInstanceManagerEvent {}

class AddEvent extends FlowInstanceManagerEvent {
  final List<FlowInstance> list;
  AddEvent({this.list});
}

class ModifyEvent extends FlowInstanceManagerEvent {
  final FlowInstance instance;
  ModifyEvent({this.instance});
}

class DeleteSingleEvent extends FlowInstanceManagerEvent {
  final FlowInstance instance;
  DeleteSingleEvent({@required this.instance});
}

class DeleteEvent extends FlowInstanceManagerEvent {
  final List<FlowInstance> instanceList;
  DeleteEvent({@required this.instanceList});
}

class FlowInstanceManagerBloc
    extends Bloc<FlowInstanceManagerEvent, FlowInstanceManagerState> {
  FlowRepository flowRepository;
  FlowInstanceManagerBloc({@required this.flowRepository})
      : assert(flowRepository != null);

  @override
  // TODO: implement initialState
  FlowInstanceManagerState get initialState => InitState();

  @override
  Stream<FlowInstanceManagerState> mapEventToState(
      FlowInstanceManagerEvent event) async* {
    if (event is RefreshEvent) {
      ReqResponse<List<FlowInstance>> req;
      if (state is InitState) {
        req = await flowRepository
            .getList(queryParams: {"product_detail": event.detail.id});
      } else {
        flowRepository.clear();
        print(event.queryParams);
        if (event.queryParams == null) {
          req = await flowRepository
              .getList(queryParams: {"product_detail": event.detail.id});
          yield LoadedState(list: req.t);
        } else {
          event.queryParams["product_detail"] = event.detail.id;
          req = await flowRepository
              .getList(queryParams: event.queryParams);
        }
        yield RefreshedState();
      }
      yield LoadedState(list: req.t);
    } else if (event is LoadMoreEvent) {
      if (flowRepository.isMax()) {
        yield NoMoreState();
        yield LoadedState(list: flowRepository.flowInstances);
      } else {
        ReqResponse<List<FlowInstance>> req = await flowRepository.getList();
        yield MoreLoadedState();
        yield LoadedState(list: req.t);
      }
    }else if(event is DeleteSingleEvent){
      bool isSuccess = await flowRepository.delete(instance: event.instance);
      if(isSuccess){
        for(FlowInstance instance in flowRepository.flowInstances){
          if(instance.id == event.instance.id){
            flowRepository.flowInstances.remove(instance);
            break;
          }
        }
        yield DoneState(isSuccess: isSuccess, message: "删除成功");
      }else{
        yield DoneState(isSuccess: isSuccess, message: "删除失败");
      }

      yield LoadedState(list: flowRepository.flowInstances);
    }else if(event is DeleteEvent){
      yield DeleteStartState();
      for(FlowInstance instance in event.instanceList){
        bool isSuccess = await flowRepository.delete(instance: instance);
        if(isSuccess)
          flowRepository.flowInstances.remove(instance);
        else{
          DeletedState();
          yield DoneState(isSuccess: false,message: "删除${instance.code}失败");
        }
      }
      yield DeletedState();
      yield LoadedState(list: flowRepository.flowInstances);
    }
  }
}
