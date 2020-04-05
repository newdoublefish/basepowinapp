import 'dart:async';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/ui/pages/flow_detail_page.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/project_respository.dart';
import 'package:manufacture/data/repository/flow_nodes_repository.dart';
import 'package:rxdart/rxdart.dart';

//abstract class ProjectState extends Equatable{
//  ProjectState([List props = const[]]):super(props);
//}

abstract class ProjectState{}

class ProjectEmpty extends ProjectState{}

class ProjectLoading extends ProjectState{}

class DataLoadedState extends ProjectState{
  final List<FlowInstance> flowInstanceList;
  final bool hasReachedMax;
  //DataLoadedState({@required this.projectList, @required this.hasReachedMax}
  DataLoadedState({@required this.flowInstanceList, @required this.hasReachedMax});
}

class ProductRefreshed extends DataLoadedState{
  ProductRefreshed({List<FlowInstance> flowInstance, bool hasReachedMax}):super(flowInstanceList:flowInstance, hasReachedMax:hasReachedMax);
}

class ProductLoaded extends DataLoadedState{
  ProductLoaded({List<FlowInstance> flowInstance, bool hasReachedMax}):super(flowInstanceList:flowInstance, hasReachedMax:hasReachedMax);
}

class ProductLoadedMore extends DataLoadedState{
  ProductLoadedMore({List<FlowInstance> flowInstance, bool hasReachedMax}):super(flowInstanceList:flowInstance, hasReachedMax:hasReachedMax);
}

abstract class ProjectEvent extends Equatable{
  ProjectEvent([List props = const[]]):super(props);
}

class FetchProjectEvent extends ProjectEvent{}

class RefreshProductEvent extends ProjectEvent{
  final Detail detail;
  final String filterString;
  RefreshProductEvent({@required this.detail, @required this.filterString}):assert(detail!=null);
}

class LoadMoreProductEvent extends ProjectEvent{
  final Detail detail;
  LoadMoreProductEvent({@required this.detail}):assert(detail!=null);
}

class FlowManagerBloc extends Bloc<ProjectEvent, ProjectState>{
  final ProjectRepository projectRepository;
  final FlowNodesRepository flowNodesRepository;
  @override
  // TODO: implement initialState
  ProjectState get initialState => ProjectEmpty();

  FlowManagerBloc({@required this.projectRepository, @required this.flowNodesRepository}):assert(projectRepository!=null,flowNodesRepository!=null);

  @override
  Stream<ProjectState> mapEventToState(event) async*{
    if (event is RefreshProductEvent) {
      if(state is ProjectEmpty){
        ReqResponse<List<Node>> res = await flowNodesRepository.getNodes(modalId: event.detail.flow);
        print(res);
        yield ProductLoaded(flowInstance: await projectRepository.fetchFlowInstanceList(detailId:event.detail.id, status: event.filterString), hasReachedMax: projectRepository.hasReachedMax);
      }else{
        projectRepository.clearFlowInstanceList(event.detail.id);
        yield ProductRefreshed(flowInstance: await projectRepository.fetchFlowInstanceList(detailId:event.detail.id, status: event.filterString), hasReachedMax: projectRepository.hasReachedMax);
      }
    }else if(event is LoadMoreProductEvent){
      yield ProductLoadedMore(flowInstance: await projectRepository.fetchFlowInstanceList(detailId:event.detail.id), hasReachedMax: projectRepository.hasReachedMax);
    }
  }
}