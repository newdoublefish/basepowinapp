import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/beans/organization.dart';
import 'package:manufacture/data/repository/detail_repository.dart';
import 'dart:async';

class ProjectDetailAddEditState {}

class InitState extends ProjectDetailAddEditState {}

class DoneState extends ProjectDetailAddEditState {
  final bool isSuccess;
  final String message;
  DoneState({this.isSuccess, this.message});
}

class ProjectDetailAddEditEvent {}

class AddEvent extends ProjectDetailAddEditEvent {
  final Detail detail;
  AddEvent({@required this.detail});
}

class ModifyEvent extends ProjectDetailAddEditEvent {
  final Detail detail;
  ModifyEvent({@required this.detail});
}

class ProjectDetailAddEditBloc
    extends Bloc<ProjectDetailAddEditEvent, ProjectDetailAddEditState> {
  final DetailRepository detailRepository;
  ProjectDetailAddEditBloc({@required this.detailRepository})
      : assert(detailRepository != null);

  @override
  ProjectDetailAddEditState get initialState => InitState();

  @override
  Stream<ProjectDetailAddEditState> mapEventToState(
      ProjectDetailAddEditEvent event) async* {
    if (event is AddEvent) {
      bool req = await detailRepository.create(detail: event.detail);
       yield DoneState(isSuccess: req, message: req?"添加成功":"添加失败");
    } else if (event is ModifyEvent) {
       bool req = await detailRepository.put(detail: event.detail);
         yield DoneState(isSuccess: req, message: req?"修改成功":"修改失败");
    }
  }
}
