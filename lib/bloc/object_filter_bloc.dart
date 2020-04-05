import 'dart:math';

import 'package:manufacture/beans/req_response.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import 'dart:async';

class ObjectFilterState{}

class InitState extends ObjectFilterState{}

class LoadedState<T extends BaseBean> extends ObjectFilterState{
  final List<T> list;
  LoadedState({this.list});
}

class ObjectFilterEvent{}

class LoadEvent extends ObjectFilterEvent{
  final Map<String, dynamic> queryParams;
  LoadEvent({this.queryParams});
}

class ObjectFilterBloc<T extends BaseBean> extends Bloc<ObjectFilterEvent, ObjectFilterState>{
  ObjectRepository<T> objectRepository;
  ObjectFilterBloc({@required this.objectRepository})
      : assert(objectRepository != null);

  @override
  ObjectFilterState get initialState => InitState();

  @override
  Stream<ObjectFilterState> mapEventToState(ObjectFilterEvent event) async*{
    if(event is LoadEvent){
      ReqResponse<List<T>> req =  await objectRepository.getList(queryParams: event.queryParams);
      yield LoadedState(list: req.t);
    }
  }

}