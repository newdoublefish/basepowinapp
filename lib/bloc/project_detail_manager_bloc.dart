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

abstract class DetailManagerState{}

class EmptyState extends DetailManagerState{}

class LoadingState extends DetailManagerState{}

class LoadedState extends DetailManagerState{
  final List<Detail> detailList;
  LoadedState({@required this.detailList});
}

class DoneState extends DetailManagerState{
  final bool isSuccess;
  final String message;
  DoneState({this.isSuccess, this.message});
}

abstract class DetailManagerEvent extends Equatable{
  DetailManagerEvent([List props = const[]]):super(props);
}


class FetchProjectDetailEvent extends DetailManagerEvent{
  final int id;
  FetchProjectDetailEvent({@required this.id}):assert(id!=null);
}

class DeleteDetailEvent extends DetailManagerEvent{
  final Detail detail;
  DeleteDetailEvent({@required this.detail}):assert(detail!=null);
}

class DetailManagerBloc extends Bloc<DetailManagerEvent, DetailManagerState>{
  final ProjectRepository projectRepository;
  final DetailRepository detailRepository;

  @override
  DetailManagerState get initialState => EmptyState();

  DetailManagerBloc({@required this.projectRepository, @required this.detailRepository}):assert(projectRepository!=null);

  @override
  Stream<DetailManagerState> mapEventToState(event) async*{
    // TODO: implement mapEventToState
    if(event is FetchProjectDetailEvent) {
      yield LoadingState();
      //List<Detail> detailList = await projectRepository.fetchProjectListDetail(event.id);
      //print(project);
      detailRepository.clear();
      ReqResponse<List<Detail>> req = await detailRepository.getDetails(queryParams: {"project": event.id});
      if(req.isSuccess) {
        yield LoadedState(detailList: req.t);
      }else{
        yield EmptyState();
      }
    }else if(event is DeleteDetailEvent){
      yield LoadingState();
      bool isSuccess = await detailRepository.delete(detail: event.detail);

      if(isSuccess){
        yield DoneState(isSuccess: true, message: "删除成功");
        for(Detail detail in detailRepository.details){
          if(detail.id == event.detail.id){
            detailRepository.details.remove(detail);
            yield LoadedState(detailList: detailRepository.details);
            break;
          }
        }
      }else{
        yield DoneState(isSuccess: true, message: "删除失败");
      }
    }
  }
}