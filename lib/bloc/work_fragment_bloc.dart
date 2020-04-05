import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/data/repository/project_respository.dart';
import 'package:manufacture/beans/project.dart';

abstract class ProjectState{
  final List<Project> projects;
  ProjectState({this.projects});
}

class ProjectEmpty extends ProjectState{}

class ProjectLoading extends ProjectState{}

class ProjectLoaded extends ProjectState{
  ProjectLoaded({List<Project> projects}):super(projects:projects);
}

class ProjectRefreshed extends ProjectLoaded{
  ProjectRefreshed({List<Project> projects}):super(projects:projects);
}

class ProjectMoreLoaded extends ProjectLoaded{
  ProjectMoreLoaded({List<Project> projects}):super(projects:projects);
}

class ProjectNoMoreData extends ProjectLoaded{
  ProjectNoMoreData({List<Project> projects}):super(projects:projects);
}

class DoneState extends ProjectState{
  final bool isSuccess;
  final String message;
  DoneState({this.isSuccess, this.message});
}

abstract class ProjectEvent extends Equatable{
  ProjectEvent([List props = const[]]):super(props);
}

class FetchProjectEvent extends ProjectEvent{
  final Map<String,dynamic> queryParams;
  FetchProjectEvent({this.queryParams=const {}}):super([queryParams]);
}

class RefreshProjectEvent extends ProjectEvent{
  final Map<String,dynamic> queryParams;
  RefreshProjectEvent({this.queryParams=const {}}):super([queryParams]);
}

class DeleteProjectEvent extends ProjectEvent{
  final Project project;
  DeleteProjectEvent({@required this.project});
}

class LoadMoreProjectEvent extends ProjectEvent{
  final Map<String,dynamic> queryParams;
  LoadMoreProjectEvent({this.queryParams=const {}}):super([queryParams]);
}

class ProjectBloc extends Bloc<ProjectEvent, ProjectState>{
  final ProjectRepository projectRepository;
  @override
  // TODO: implement initialState
  ProjectState get initialState => ProjectLoaded(projects: []);

  ProjectBloc({@required this.projectRepository}):assert(projectRepository!=null);

  @override
  Stream<ProjectState> mapEventToState(event) async* {
    // TODO: implement mapEventToState
    if (event is FetchProjectEvent) {
        yield ProjectLoaded(projects: await projectRepository.loadProjectList(queryParams: event.queryParams));
    }else if(event is RefreshProjectEvent){
      projectRepository.clearProjectList();
      yield ProjectRefreshed(projects: await projectRepository.loadProjectList(queryParams: event.queryParams));
    }else if(event is LoadMoreProjectEvent){
      if(projectRepository.hasReachedMax!=true)
        yield ProjectMoreLoaded(projects: await projectRepository.loadProjectList(queryParams: event.queryParams));
      else
        yield ProjectNoMoreData(projects: await projectRepository.loadProjectList(queryParams: event.queryParams));
    }else if(event is DeleteProjectEvent){
      if(await projectRepository.delete(project: event.project)){
        yield DoneState(isSuccess: true, message: "删除成功");
        projectRepository.projectList.remove(event.project);
        yield ProjectLoaded(projects: projectRepository.projectList);
      }else{
        yield DoneState(isSuccess: false, message: "删除失败");
      }
    }
  }
}