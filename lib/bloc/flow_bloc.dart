import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/project_respository.dart';

abstract class FlowState extends Equatable{
  FlowState([List props = const[]]):super(props);
}

class FlowEmptyState extends FlowState{}

class FlowLoadingState extends FlowState{}

class FlowLoadedState extends FlowState{
  final List<FlowHistory> historyList;
  FlowLoadedState({@required this.historyList});
}


abstract class FlowEvent extends Equatable{
  FlowEvent([List props = const[]]):super(props);
}

class FetchProductFlowEvent extends FlowEvent{
  final int flowInstanceId;
  FetchProductFlowEvent({@required this.flowInstanceId});
}


class FlowBloc extends Bloc<FlowEvent, FlowState>{
  final ProjectRepository projectRepository;

  FlowBloc({@required this.projectRepository}):assert(projectRepository!=null);
  @override
  // TODO: implement initialState
  FlowState get initialState => FlowEmptyState();

  @override
  Stream<FlowState> mapEventToState(FlowEvent event) async*{
    // TODO: implement mapEventToState
    if(event is FetchProductFlowEvent)
    {
      yield FlowLoadingState();
      List<FlowHistory> _list=await projectRepository.fetchFlowHistoryList(event.flowInstanceId);
      print(_list);
      yield FlowLoadedState(historyList: _list);
    }
  }
}