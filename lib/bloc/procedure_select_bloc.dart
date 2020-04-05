import 'dart:async';
import 'package:manufacture/beans/req_response.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:manufacture/beans/project.dart';
import 'package:manufacture/data/repository/flow_modals_repository.dart';

class ProcedureSelectState{}

class ProcedureInitState extends ProcedureSelectState{}

class ProcedureLoadState extends ProcedureSelectState{
  final List<Procedure> procedureList;
  final Procedure current;
  ProcedureLoadState({this.procedureList,this.current});
}

class ProcedureSelected extends ProcedureSelectState{
  final Procedure current;
  ProcedureSelected({this.current});
}

class ProcedureSelectEvent{}

class ProcedureLoadEvent extends ProcedureSelectEvent{}

class ProcedureDoSelectEvent extends ProcedureSelectEvent{
  final int id;
  ProcedureDoSelectEvent({this.id});
}

class ProcedureSelectBloc extends Bloc<ProcedureSelectEvent, ProcedureSelectState>{
  final FlowModalsRepository repository;
  ProcedureSelectBloc({@required this.repository});
  @override
  ProcedureSelectState get initialState => ProcedureInitState();
  @override
  Stream<ProcedureSelectState> mapEventToState(ProcedureSelectEvent event) async*{
    if(event is ProcedureLoadEvent){
      if(repository.modals.length==0){
        ReqResponse<List<Procedure>> req = await repository.getModals();
      }
      yield ProcedureLoadState(procedureList: repository.modals, current: repository.modals[0]);
    }else if(event is ProcedureDoSelectEvent){
      if(repository.modals.length==0){
        ReqResponse<List<Procedure>> req = await repository.getModals();
      }
      for(var procedure in repository.modals){
        if(procedure.id == event.id){
          yield ProcedureLoadState(procedureList: repository.modals, current: procedure);
          return;
        }
      }
      yield ProcedureLoadState(procedureList: repository.modals, current: repository.modals[0]);
    }
  }
}