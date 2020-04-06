import 'dart:async';
import 'package:manufacture/beans/req_response.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import 'package:manufacture/beans/base_bean.dart';

class ObjectManagerState {}

class InitState extends ObjectManagerState {}

class LoadingState extends ObjectManagerState {}

class LoadedState<T> extends ObjectManagerState {
  final List<T> list;
  final int currentCount;
  final int totalCount;
  LoadedState({this.list, this.currentCount, this.totalCount});
}

class NoMoreState extends ObjectManagerState {}

class MoreLoadedState extends ObjectManagerState {}

class RefreshedState extends ObjectManagerState {}

class DoneState extends ObjectManagerState {
  final bool isSuccess;
  final String message;
  DoneState({this.isSuccess, this.message});
}

class DeleteStartState extends ObjectManagerState {}

class DeletingState extends ObjectManagerState {
  final double progress;
  DeletingState({this.progress});
}

class DeletedState extends ObjectManagerState {}

class ObjectManagerEvent {}

class LoadMoreEvent extends ObjectManagerEvent {}

class RefreshEvent<T> extends ObjectManagerEvent {
  final Map<String, dynamic> queryParams;
  RefreshEvent({this.queryParams});
}

class AddEvent<T> extends ObjectManagerEvent {
  final List<T> list;
  AddEvent({this.list});
}

class ModifyEvent<T> extends ObjectManagerEvent {
  final T instance;
  ModifyEvent({this.instance});
}

class DeleteSingleEvent<T> extends ObjectManagerEvent {
  final T instance;
  DeleteSingleEvent({@required this.instance});
}

class DeleteEvent<T> extends ObjectManagerEvent {
  final List<T> instanceList;
  DeleteEvent({@required this.instanceList});
}

class ObjectManagerBloc<T extends BaseBean>
    extends Bloc<ObjectManagerEvent, ObjectManagerState> {
  ObjectRepository<T> objectRepository;
  ObjectManagerBloc({@required this.objectRepository})
      : assert(objectRepository != null);

  @override
  ObjectManagerState get initialState => InitState();

  @override
  Stream<ObjectManagerState> mapEventToState(ObjectManagerEvent event) async* {
    if (event is RefreshEvent) {
      ReqResponse<List<T>> req;
      if (state is InitState) {
        req = await objectRepository.getList(queryParams: event.queryParams);
      } else {
        objectRepository.clear();
        if (event.queryParams == null) {
          req = await objectRepository.getList(queryParams: event.queryParams);
          yield LoadedState(
              list: req.t,
              currentCount: objectRepository.current,
              totalCount: objectRepository.total);
        } else {
          req = await objectRepository.getList(queryParams: event.queryParams);
        }
        yield RefreshedState();
      }
      yield LoadedState(
          list: req.t,
          currentCount: objectRepository.current,
          totalCount: objectRepository.total);
    } else if (event is LoadMoreEvent) {
      if (objectRepository.isMax()) {
        yield NoMoreState();
        yield LoadedState(
            list: objectRepository.list,
            currentCount: objectRepository.current,
            totalCount: objectRepository.total);
      } else {
        ReqResponse<List<T>> req = await objectRepository.getList();
        yield MoreLoadedState();
        yield LoadedState(
            list: req.t,
            currentCount: objectRepository.current,
            totalCount: objectRepository.total);
      }
    } else if (event is DeleteSingleEvent) {
      bool isSuccess = await objectRepository.delete(obj: event.instance);
      if (isSuccess) {
//        for(T instance in objectRepository.list){
//          if(instance.id == event.instance.id){
//            objectRepository.list.remove(instance);
//            break;
//          }
//        }
        objectRepository.list.remove(event.instance);
        yield DoneState(isSuccess: isSuccess, message: "删除成功");
      } else {
        yield DoneState(isSuccess: isSuccess, message: "删除失败");
      }

      yield LoadedState(
          list: objectRepository.list,
          currentCount: objectRepository.current,
          totalCount: objectRepository.total);
    } else if (event is DeleteEvent) {
      yield DeleteStartState();
      int succssCnt = 0;
      for (T instance in event.instanceList) {
        bool isSuccess = await objectRepository.delete(obj: instance);
        if (isSuccess) {
          succssCnt++;
          objectRepository.list.remove(instance);
          yield DeletingState(progress: succssCnt*100 / event.instanceList.length);
        } else {
          DeletedState();
          yield DoneState(isSuccess: false, message: "删除失败");
        }
      }
      yield DeletedState();
      yield LoadedState(
          list: objectRepository.list,
          currentCount: objectRepository.current,
          totalCount: objectRepository.total);
    }
  }
}
