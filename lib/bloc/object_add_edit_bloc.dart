import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import 'dart:async';

class ObjectAddEditState {}

class InitState extends ObjectAddEditState {}

class DoneState extends ObjectAddEditState {
  final bool isSuccess;
  final String message;
  DoneState({this.isSuccess, this.message});
}

class ObjectAddEditEvent {}

class AddEvent<T extends BaseBean> extends ObjectAddEditEvent {
  final T object;
  AddEvent({@required this.object});
}

class ModifyEvent<T extends BaseBean> extends ObjectAddEditEvent {
  final T object;
  ModifyEvent({@required this.object});
}

class ObjectAddEditBloc<T extends BaseBean>
    extends Bloc<ObjectAddEditEvent, ObjectAddEditState> {
  final ObjectRepository<T> objectRepository;
  ObjectAddEditBloc({@required this.objectRepository})
      : assert(objectRepository != null);

  @override
  ObjectAddEditState get initialState => InitState();

  @override
  Stream<ObjectAddEditState> mapEventToState(
      ObjectAddEditEvent event) async* {
    if (event is AddEvent) {
      bool req = await objectRepository.create(obj: event.object);;
      yield DoneState(isSuccess: req, message: req?"添加成功":"添加失败");
    } else if (event is ModifyEvent) {
      bool req = await objectRepository.put(obj: event.object);
      yield DoneState(isSuccess: req, message: req?"修改成功":"修改失败");
    }
  }
}
