import 'dart:async';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/data/repository/detail_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/project_respository.dart';
import 'package:rxdart/rxdart.dart';

//abstract class ProjectState extends Equatable{
//  ProjectState([List props = const[]]):super(props);
//}

abstract class ProjectState{}

class ProjectEmpty extends ProjectState{}

class ProjectLoading extends ProjectState{}

class ProjectDetailLoaded extends ProjectState{
  final List<Detail> detailList;
  ProjectDetailLoaded({@required this.detailList});
}

abstract class ProjectEvent extends Equatable{
  ProjectEvent([List props = const[]]):super(props);
}


class FetchProjectDetailEvent extends ProjectEvent{
  final int id;
  FetchProjectDetailEvent({@required this.id}):assert(id!=null);
}

class ProjectBloc extends Bloc<ProjectEvent, ProjectState>{
  final ProjectRepository projectRepository;
  final DetailRepository detailRepository;
  @override
  // TODO: implement initialState
  ProjectState get initialState => ProjectEmpty();

  ProjectBloc({@required this.projectRepository, @required this.detailRepository}):assert(projectRepository!=null);

  @override
  Stream<ProjectState> mapEventToState(event) async*{
    // TODO: implement mapEventToState
  if(event is FetchProjectDetailEvent) {
      yield ProjectLoading();
      //List<Detail> detailList = await projectRepository.fetchProjectListDetail(event.id);
      //print(project);
      detailRepository.clear();
      ReqResponse<List<Detail>> req = await detailRepository.getDetails(queryParams: {"project": event.id});
      if(req.isSuccess) {
        yield ProjectDetailLoaded(detailList: req.t);
      }else{
        yield ProjectEmpty();
      }
    }
  }
}