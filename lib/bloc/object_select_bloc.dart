import 'dart:async';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/beans/req_response.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';


class ObjectSelectState{}

class InitState extends ObjectSelectState{}

class LoadState<T extends BaseBean> extends ObjectSelectState{
  final List<T> objects;
  final T current;
  LoadState({this.objects,this.current});
}


class SelectedState<T extends BaseBean> extends ObjectSelectState{
  final T current;
  SelectedState({this.current});
}

class ObjectSelectEvent{}

class LoadEvent extends ObjectSelectEvent{
  final Map<String, dynamic> queryParams;
  LoadEvent({this.queryParams});
}

class ReLoadEvent extends ObjectSelectEvent{
  final Map<String, dynamic> queryParams;
  ReLoadEvent({this.queryParams});
}

class DoSelectEvent<T extends BaseBean> extends ObjectSelectEvent{
  final T obj;
  DoSelectEvent({this.obj});
}

class ObjectSelectBloc<T extends BaseBean> extends Bloc<ObjectSelectEvent, ObjectSelectState>{
  final ObjectRepository<T> objectRepository;
  ObjectSelectBloc({@required this.objectRepository});
  @override
  ObjectSelectState get initialState => InitState();
  @override
  Stream<ObjectSelectState> mapEventToState(ObjectSelectEvent event) async*{
    if(event is ReLoadEvent) {
      objectRepository.clear();
      ReqResponse<List<T>> req = await objectRepository.getList(
            queryParams: event.queryParams);
      yield LoadState<T>(
          objects: objectRepository.list, current: null);
    }else if(event is LoadEvent){
      if(objectRepository.list.length==0){
        ReqResponse<List<T>> req = await objectRepository.getList(queryParams: event.queryParams);
      }
      yield LoadState<T>(objects: objectRepository.list, current: null);
    }else if(event is DoSelectEvent){
      if(objectRepository.list.length==0){
        ReqResponse<List<T>> req = await objectRepository.getList();
      }
      for(var object in objectRepository.list){
        if(object.id == event.obj.id){
          yield LoadState(objects: objectRepository.list, current: object);
          return;
        }
      }
      yield LoadState<T>(objects: objectRepository.list, current: null);
    }
  }
}