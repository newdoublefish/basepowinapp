import 'package:manufacture/beans/req_response.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/project_respository.dart';
import 'dart:async';

class ProjectAddEditState{}

class InitState extends ProjectAddEditState{}

class LoadedState extends ProjectAddEditState{
}

class DoneState extends ProjectAddEditState{
  final bool isSuccess;
  final String message;
  DoneState({this.isSuccess, this.message});
}

class ProjectAddEditEvent{}

class AddEvent extends ProjectAddEditEvent{
  final Project project;
  AddEvent({@required this.project});
}

class ModifyEvent extends ProjectAddEditEvent{
  final Project project;
  ModifyEvent({@required this.project});
}

class ProjectAddEditBloc extends Bloc<ProjectAddEditEvent, ProjectAddEditState>{
  final ProjectRepository projectRepository;
  ProjectAddEditBloc({@required this.projectRepository}):assert(projectRepository!=null);

  @override
  ProjectAddEditState get initialState => InitState();

  @override
  Stream<ProjectAddEditState> mapEventToState(ProjectAddEditEvent event) async*{
    if(event is AddEvent){
      ReqResponse<Project> req = await projectRepository.create(project: event.project);
      yield DoneState(isSuccess: req.isSuccess, message: req.isSuccess?"添加成功":"添加失败");
    }else if(event is ModifyEvent){
      ReqResponse<Project> req = await projectRepository.update(project: event.project);
      yield DoneState(isSuccess: req.isSuccess, message: req.isSuccess?"添加成功":"添加失败");
    }
  }

}