import 'dart:async';
import 'package:manufacture/beans/base_bean.dart';
import 'package:manufacture/data/repository/object_repository.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

class GenerateState {}

class InitState extends GenerateState {}

class CreatedState extends GenerateState {
  final bool isSuccess;
  final String message;
  CreatedState({this.isSuccess, this.message});
}

class CreatingState extends GenerateState {
  final String code;
  final double progress;
  CreatingState({this.code, this.progress});
}

class CreateStartState extends GenerateState {}

class ParseErrorState extends GenerateState {
  final String message;
  ParseErrorState({this.message});
}

class CommitState extends GenerateState {
  final String start;
  final String end;
  final int total;
  CommitState({this.start, this.end, this.total});
}

class DoneState extends GenerateState {
  final bool isSuccess;
  final String message;
  DoneState({this.isSuccess, this.message});
}

class GenerateEvent {}

class CommitEvent extends GenerateEvent {
  final String prefix;
  final String suffix;
  final String start;
  final String end;
  final String count;

  CommitEvent({this.prefix, this.suffix, this.start, this.end, this.count});
}

class ConfirmEvent<T extends BaseBean> extends GenerateEvent {
  final List<T> list;
  ConfirmEvent({this.list});
}

class ObjectGenerateBloc<T extends BaseBean>
    extends Bloc<GenerateEvent, GenerateState> {
  final ObjectRepository<T> objectRepository;
  StringBuffer sb = new StringBuffer();
  ObjectGenerateBloc({@required this.objectRepository})
      : assert(objectRepository != null);
  @override
  GenerateState get initialState => InitState();


  void append(StringBuffer sb, int len, int num){
    sb.clear();
    int zeroCnt = len - num.toString().length;
    for(int i=0;i<zeroCnt;i++){
      sb.write('0');
    }
    sb.write(num.toString());
  }


  @override
  Stream<GenerateState> mapEventToState(
      GenerateEvent event) async* {
    if (event is CommitEvent) {
      if (event.count.length == 0 && event.end.length == 0) {
        yield ParseErrorState(message: "结束与数量必须有一个要填");
        return;
      }

      if (event.end.length != 0) {
        int len = event.start.toString().length;
        if (len != event.end.toString().length) {
          yield ParseErrorState(message: "开始与结束的数字位数不一致");
          return;
        }

        if (int.parse(event.start.toString()) >
            int.parse(event.end.toString())) {
          yield ParseErrorState(message: "结束编号小于开始编号");
          return;
        }

        yield CommitState(
          start: "${event.prefix}${event.start.toString()}${event.suffix}",
          end: "${event.prefix}${event.end.toString()}${event.suffix}",
          total: int.parse(event.end.toString()) -
              int.parse(event.start.toString()) +
              1,
        );
      }
    } else if (event is ConfirmEvent) {
      yield CreateStartState();
      int len = event.list.length;
      for(int i=0;i< len;i++){
        bool req = await objectRepository.create(obj: event.list[i]);
        yield CreatingState(progress: i*100/len.toDouble(),);
      }

//      int len = event.start.length;
//      int start = int.parse(event.start);
//
//      for (int i = start; i <= state.total; i++) {
//        await Future.delayed(Duration(milliseconds: 200));
//        Tech instance = Tech();
//        append(sb, len, i);
//        instance.code = "${event.prefix}${sb.toString()}${event.suffix}";
//        instance.project = event.project;
//
//        bool flag = await techObjectRepository.create(obj:instance);
//        print(flag);
//        //
////        bool req = await flowRepository.create(instance: instance);
////        print(req);
//        yield CreatingState(progress: i.toDouble(),productCode: "${event.prefix}${sb.toString()}${event.suffix}");
//      }
      yield CreatedState();
    }
  }
}
