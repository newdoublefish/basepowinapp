import 'dart:async';
import 'package:manufacture/beans/req_response.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:manufacture/beans/record.dart';
import 'package:manufacture/data/repository/record_type_repository.dart';

class RecordTypeSelectState{}

class RecordTypeInitState extends RecordTypeSelectState{}

class RecordTypeLoadState extends RecordTypeSelectState{
  final List<RecordType> recordTypeList;
  final RecordType current;
  RecordTypeLoadState({this.recordTypeList,this.current});
}

class RecordTypeSelected extends RecordTypeSelectState{
  final RecordType recordType;
  RecordTypeSelected({this.recordType});
}

class RecordTypeSelectEvent{}

class RecordTypeLoadEvent extends RecordTypeSelectEvent{}

class RecordTypeDoSelectEvent extends RecordTypeSelectEvent{
  final int typeId;
  RecordTypeDoSelectEvent({this.typeId});
}

class RecordTypeBloc extends Bloc<RecordTypeSelectEvent, RecordTypeSelectState>{
  final RecordRepository repository;
  RecordTypeBloc({@required this.repository});
  @override
  RecordTypeSelectState get initialState => RecordTypeInitState();
  @override
  Stream<RecordTypeSelectState> mapEventToState(RecordTypeSelectEvent event) async*{
    if(event is RecordTypeLoadEvent){
      if(repository.recordTypeList.length==0){
        ReqResponse<List<RecordType>> req = await repository.getRecordTypeList();
      }
      yield RecordTypeLoadState(recordTypeList: repository.recordTypeList, current: repository.recordTypeList[0]);
    }else if(event is RecordTypeDoSelectEvent){
      if(repository.recordTypeList.length==0){
        ReqResponse<List<RecordType>> req = await repository.getRecordTypeList();
      }
      for(var recordType in repository.recordTypeList){
        if(recordType.id == event.typeId){
            yield RecordTypeLoadState(recordTypeList: repository.recordTypeList, current: recordType);
            return;
        }
      }
      yield RecordTypeLoadState(recordTypeList: repository.recordTypeList, current: repository.recordTypeList[0]);
    }
  }
}