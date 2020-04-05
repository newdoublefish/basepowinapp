import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/beans/progress.dart';
import 'package:manufacture/data/repository/progress_repository.dart';

abstract class ProgressState extends Equatable{
  ProgressState([List props = const[]]):super(props);
}

class InitState extends ProgressState{}

class LoadingState extends ProgressState{}

class ProgressLoadedState extends ProgressState{
  final Progress progress;
  ProgressLoadedState({this.progress});
}

abstract class ProgressEvent extends Equatable{
  ProgressEvent([List props = const[]]):super(props);
}

class FetchProgressEvent extends ProgressEvent{
  final int detailId;
  FetchProgressEvent({@required this.detailId});

}

class ProgressBloc extends Bloc<ProgressEvent, ProgressState>{
  final ProgressRepository progressRepository;

  ProgressBloc({@required this.progressRepository});

  @override
  // TODO: implement initialState
  ProgressState get initialState => InitState();

  @override
  Stream<ProgressState> mapEventToState(ProgressEvent event) async*{
    // TODO: implement mapEventToState
    if(event is FetchProgressEvent){
      yield LoadingState();
      Progress progress = await progressRepository.getDetailProgress(detailId: event.detailId);
      yield ProgressLoadedState(progress: progress);
    }
  }

}

